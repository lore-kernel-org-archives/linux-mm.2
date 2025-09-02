Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24D5ACA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 13:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806B16B0005; Tue,  2 Sep 2025 09:42:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B7076B0006; Tue,  2 Sep 2025 09:42:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A5946B0007; Tue,  2 Sep 2025 09:42:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4C9236B0005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 09:42:37 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03343C017E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:42:36 +0000 (UTC)
X-FDA: 83844425154.16.1070B81
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.19])
	by imf27.hostedemail.com (Postfix) with ESMTP id 344AA4000E
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:42:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TnX27W2b;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf27.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.19) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756820554; a=rsa-sha256;
	cv=none;
	b=3QbFK3zq5PhJmmzDK+baAIdgheV/QKswk+tXd5MbRaNAAOpqpYTEFj0TRS2Lz9WcJ7o9Yv
	FtVkWePkNSnpn0uTlLn31yB9ibgzR2K6JBgn31apkkf5Ae6F+oAA9I8niTlUQWlEEVq3Qu
	rbhxlGgr5HdnZ+bic5jTdNkNHdmJvyY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=TnX27W2b;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=none (imf27.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.19) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756820554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dlnqyeR+5I6qruWbk7IABHALhsF2hRcTjNBGT4VTdMM=;
	b=63XDbVZ+fYAYV8GNX3zg6UqmZvFxpZo9TJDkZU/Js3tT30WH1NL5w3ZpIpi4C8WeJKmGLf
	I4ekMVhuPGL6unLQaMCkbZBMk3mkfguSDsR7rI7UhH0PlCgun6jyO5XbcbIgPP4zHdjGPD
	q5EKKaKDbpxGK82a/B71WstSdxNbTAk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756820555; x=1788356555;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=dlnqyeR+5I6qruWbk7IABHALhsF2hRcTjNBGT4VTdMM=;
  b=TnX27W2bd8MSnPDkMCApxQoxnSjCM62WnjAARwpU9c/FlXWaEWitmFba
   JTeQ5BuhnViMzkEROcQahpDr82oAdEUm0LCQz3COW77DiBL0Qw7+ldRhd
   UFmO/p8hTqN8vvINeg1BxsQUHUyzhcZk7tyv40e/Y4Ko1XYH09UI3A5R9
   MDFrAEOjj1Hroa0eCab0V7OxRKMnB0LPANgbr7pu8UGld+WEte3HirTEk
   BW7kKOeBsebhPcijr1R+QBq8Z5zwCqRpczbt9DwIC8O2O75qsmGQw6gDN
   8bUHjwLebXsNK7DN9TwuaOklzjiBDNjAtenTVKbeAnIBhxen+IBMYWXXr
   A==;
X-CSE-ConnectionGUID: tLqYrVCQR5KDUyx1E2Y/Cg==
X-CSE-MsgGUID: sDk5fz6ARyKszwtPXZKAWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11541"; a="58951216"
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="58951216"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa111.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:42:33 -0700
X-CSE-ConnectionGUID: 87TOoN+JSuyyXu64BJLX8Q==
X-CSE-MsgGUID: XyDjfStqRz6SEEHMNLLv9g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="171175094"
Received: from dalessan-mobl3.ger.corp.intel.com (HELO [10.245.245.33]) ([10.245.245.33])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2025 06:42:26 -0700
Message-ID: <da5885a94d89a2c0dece04e09182e832e8e40410.camel@linux.intel.com>
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: David Hildenbrand <david@redhat.com>, Maarten Lankhorst
 <dev@lankhorst.se>,  Lucas De Marchi <lucas.demarchi@intel.com>, Rodrigo
 Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,  Simona
 Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>, Natalie Vock
 <natalie.vock@gmx.de>,  Tejun Heo <tj@kernel.org>, Johannes Weiner
 <hannes@cmpxchg.org>, 'Michal =?ISO-8859-1?Q?Koutn=FD=27?=	
 <mkoutny@suse.com>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin	
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Muchun
 Song	 <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "'Liam R . Howlett'"
 <Liam.Howlett@oracle.com>,  Vlastimil Babka	 <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Thomas
 Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Date: Tue, 02 Sep 2025 15:42:20 +0200
In-Reply-To: <776629b2-5459-4fa0-803e-23d4824e7b24@redhat.com>
References: <20250819114932.597600-5-dev@lankhorst.se>
	 <dc21e54c-d7ae-4d7e-9acb-6a3fa573b20f@redhat.com>
	 <9c296c72-768e-4893-a099-a2882027f2b9@lankhorst.se>
	 <b6b13ad22345bcdf43325173052614c17e803d00.camel@linux.intel.com>
	 <776629b2-5459-4fa0-803e-23d4824e7b24@redhat.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 344AA4000E
X-Stat-Signature: tgekccwgc41xhody54z6nmimkw4rzq1h
X-HE-Tag: 1756820553-663302
X-HE-Meta: U2FsdGVkX1/I5ny3EGRa+S1q4t0bI2vACUoIPe77M4qrMhJtZNtgDiC2lSH9c+HEb+pcENlVhGddBwoHndNIO8E1DJdwX1B1yJdzxjSUvb8xNjvBiGaBQ4crhj+Fr29oI34bDEjVBOKyYJ2BP9/MrpbRLXEqXZIT8agMB6iODBlvDylxWM8mhHClAnd4lytSdqSgGAhbkUmijtRoC8I0JYZjK4cmkhk7rw7JUEK3b2dY0MS6x1UTqxa6MXssrBWbOGLuJVYCiTMnFwdtd3CCLTm3QZgkQOfXO94wrZGQC9iTl4RtFVIVnvs+RHkzyOustmsmsPRN6/XyOeicEmZLYIasAQ+x9TVhHFrXFi4fc4zI2AzjDpzqhKAgPCc9/R4siqweOtF6luBDPzpopj3Dat1hqM8Xx/MdnRfgTZCiz0PFIa5BStKavOycENgeebByIWepbrS5vRvDG9Kfun2vSM48/7ip+By/xkPv6mYV0KXXeQA/l5VY8kbCbR+ttYV+NjfbATm1RzZ6ydmwTU5ueNjqjVAQPmlSelUVQkWre7qSHoPIcGLMV8xEL+TKb01kwPOBSSCi5eB50sfcLKrhRi5uqax6uAFGTSkK+qd7dHoGZqIpBD7Inq6yJuDe/vxbGIKip6oGbbcYYY/PRkUn1x4HYuPtktJvq10Sg5bSsDc6gmcQ4JOLpSAlULAB38vOwvWC34Xs+feqbXMK1X6fJD9qreJoyCJ7kBNrVmJpuMJOt77zxsipKjx44/HyY6b8Bzc35iQK45PhTYxZtLLFqPqgwIyXc0Ue+tb9u+rrBuBi+c6yafP+Pku7Pt5l6mA83KSelqXaf+4bNnbmtR77seruvJnbZwQ7Yhn5XOxqRouswQgZTm1wIcq2ccqMT9xTVA1cTlSnI+Ga/hk1GPUs9U9GLjDEt8MY01j6xo+pvU5er854O7jhpS8sLNZwL/VzSqINPM6hu9/1szfatnc
 XJKIFieW
 IkuF26JQ9TXEj71Ge2l4y0h6l0Uew6fEpWDDC5R+mI1/tKf7wn4z+IAyIdWlDjYw2cbxjTRITmscwtdLafhXEm2fw9yk8pAT6esgJ47UIf9MZtcZaO3gSgx4KrHPcQU8VuMFrt3W5MsQ4OmFL4xC2tmwvVxsI7PP/QzQnGKH0teMONV4eUhE76534rm0M66lH0rfpm05AP15R3JUeo1KrZ+GhhYN+lDfpXbrevOlA65HyJyA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2025-09-01 at 20:38 +0200, David Hildenbrand wrote:
> On 01.09.25 20:21, Thomas Hellstr=C3=B6m wrote:
> > Hi,
> >=20
> > On Mon, 2025-09-01 at 20:16 +0200, Maarten Lankhorst wrote:
> > > Hello David,
> > >=20
> > > Den 2025-09-01 kl. 14:25, skrev David Hildenbrand:
> > > > On 19.08.25 13:49, Maarten Lankhorst wrote:
> > > > > When exporting dma-bufs to other devices, even when it is
> > > > > allowed
> > > > > to use
> > > > > move_notify in some drivers, performance will degrade
> > > > > severely
> > > > > when
> > > > > eviction happens.
> > > > >=20
> > > > > A perticular example where this can happen is in a multi-card
> > > > > setup,
> > > > > where PCI-E peer-to-peer is used to prevent using access to
> > > > > system memory.
> > > > >=20
> > > > > If the buffer is evicted to system memory, not only the
> > > > > evicting
> > > > > GPU wher
> > > > > the buffer resided is affected, but it will also stall the
> > > > > GPU
> > > > > that is
> > > > > waiting on the buffer.
> > > > >=20
> > > > > It also makes sense for long running jobs not to be preempted
> > > > > by
> > > > > having
> > > > > its buffers evicted, so it will make sense to have the
> > > > > ability to
> > > > > pin
> > > > > from system memory too.
> > > > >=20
> > > > > This is dependant on patches by Dave Airlie, so it's not part
> > > > > of
> > > > > this
> > > > > series yet. But I'm planning on extending pinning to the
> > > > > memory
> > > > > cgroup
> > > > > controller in the future to handle this case.
> > > > >=20
> > > > > Implementation details:
> > > > >=20
> > > > > For each cgroup up until the root cgroup, the 'min' limit is
> > > > > checked
> > > > > against currently effectively pinned value. If the value will
> > > > > go
> > > > > above
> > > > > 'min', the pinning attempt is rejected.
> > > > >=20
> > > > > Pinned memory is handled slightly different and affects
> > > > > calculating
> > > > > effective min/low values. Pinned memory is subtracted from
> > > > > both,
> > > > > and needs to be added afterwards when calculating.
> > > >=20
> > > > The term "pinning" is overloaded, and frequently we refer to
> > > > pin_user_pages() and friends.
> > > >=20
> > > > So I'm wondering if there is an alternative term to describe
> > > > what
> > > > you want to achieve.
> > > >=20
> > > > Is it something like "unevictable" ?
> > > It could be required to include a call pin_user_pages(), in case
> > > a
>=20
> We'll only care about long-term pinnings (i.e., FOLL_LONGTERM).
> Ordinary=20
> short-term pinning is just fine.
>=20
> (see how even "pinning" is overloaded? :) )
>=20
> > > process wants to pin
> > > from a user's address space to the gpu.
> > >=20
> > > It's not done yet, but it wouldn't surprise me if we want to
> > > include
> > > it in the future.
> > > Functionally it's similar to mlock() and related functions.
>=20
> Traditionally, vfio, io_uring and rdma do exactly that: they use GUP
> to=20
> longterm pin and then account that memory towards RLIMIT_MEMLOCK.
>=20
> If you grep for "rlimit(RLIMIT_MEMLOCK)", you'll see what I mean.
>=20
> There are known issues with that: imagine long-term pinning the same=20
> folio through GUP with 2 interfaces (e.g., vfio, io_uring, rdma), or=20
> within the same interface.
>=20
> You'd account the memory multiple times, which is horrible. And so
> far=20
> there is no easy way out.
>=20
> > >=20
> > > Perhaps call it mlocked instead?
> >=20
> > I was under the impression that mlocked() memory can be migrated to
> > other physical memory but not to swap? whereas pinned memory needs
> > to
> > remain the exact same physical memory.
>=20
> Yes, exactly.
>=20
> >=20
> > IMO "pinned" is pretty established within GPU drivers (dma-buf,
> > TTM)
> > and essentially means the same as "pin" in "pin_user_pages", so
> > inventing a new name would probably cause even more confusion?
>=20
> If it's the same thing, absolutely. But Marteen said "It's not done
> yet,=20
> but it wouldn't surprise me if we want to include it in the future".
>=20
> So how is the memory we are talking about in this series "pinned" ?

Reading the cover-letter from Maarten, he only talks about pinning
affecting performance, which would be similar to user-space calling
mlock(), although I doubt that moving content to other physical pages
within the same memory type will be a near-term use-case.

However what's more important are situation where a device (like RDMA)
needs to pin, because it can't handle the case where access is
interrupted and content transferred to another physical location.

Perhaps Maarten could you elaborate whether this series is intended for
both these use-cases?

/Thomas



>=20
>=20


