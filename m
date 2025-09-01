Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C05CA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 18:22:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5235A8E0002; Mon,  1 Sep 2025 14:22:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4FB6F8E0001; Mon,  1 Sep 2025 14:22:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 411CD8E0002; Mon,  1 Sep 2025 14:22:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 306858E0001
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:22:07 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9D72784F51
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:22:06 +0000 (UTC)
X-FDA: 83841500652.27.73CDDEE
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	by imf21.hostedemail.com (Postfix) with ESMTP id D3B6E1C0003
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 18:22:03 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EHXzRHwM;
	spf=none (imf21.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.14) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756750924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d3BjrklD0G2phAKakK8SAVU5KohAaT/0bo4d3rBYrZ4=;
	b=pDhaLfFRSkM5SDmbO0pKcxRc7Q0k6YRCX/UaybyjAc0IO2RvwwkUdzhYJdQjPGqod7JTuv
	UBbvKV75dcmm7upRmipYnyzehMGF2dpEW0LzSyUAyB+lGFv4edsBPp4SKduZB6x+Hgg/NQ
	qQpHpfUlKVvUoqDq8sKKljTZBVXQ3AI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=EHXzRHwM;
	spf=none (imf21.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 198.175.65.14) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756750924; a=rsa-sha256;
	cv=none;
	b=Tfp2/802vA/FMyu19xI1kC1KI6pEBHPnIP4Ou9w1f4T8NEWqhdbEaOBerptZCBvDPk8aXb
	MtylJU+HyOFHj3ZyE0yRAqguOUaj9+TMAmfDdBRRnGq8ru4Jm2a7iZXNgK/HqzDcStjbiV
	ovQLNfrXCftg67G17h4XW8Q57qeSgPM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756750924; x=1788286924;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=d3BjrklD0G2phAKakK8SAVU5KohAaT/0bo4d3rBYrZ4=;
  b=EHXzRHwMeNAjxsXZZpTg+ei0rJAfFXGXXRIb0IIORZQKtkpkqUiHa4l1
   W+zm17KcHU7Al8efXhKau7oiKCMNBrhE3wgH1bOYVUyW90S2+d5fnvCHg
   ajcTiHQ6b2H6HTtDaHF0WptIEh/wCl6ScU6pBelQfz5mOqEFANf4ZaANo
   XbtXAWW+w4P4Y/yt/mBnTskj36OG09VniZQDZ4rH14KuB5Ce6PZAYbtIz
   3WtZcvKe9nCBcwJ6Rte6E9mBsF0qz6QKY0CNXTtXN0CM2Yb54/6+9Zd/k
   jyqKx7t30B5RcU5m7lKsIAYos09+QbyuqerjhxdAKmSBmKX+8cbf1++P2
   A==;
X-CSE-ConnectionGUID: uTR2CryZTFylnNo+XV5RHA==
X-CSE-MsgGUID: 2ynzSqEWSOCggIh9jVh0ng==
X-IronPort-AV: E=McAfee;i="6800,10657,11531"; a="62846687"
X-IronPort-AV: E=Sophos;i="6.17,312,1747724400"; 
   d="scan'208";a="62846687"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 11:22:03 -0700
X-CSE-ConnectionGUID: l3vRZl7yRLa9+4KiPRrykA==
X-CSE-MsgGUID: VSICzs7zTJiLad48qf7TGA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,230,1751266800"; 
   d="scan'208";a="170350870"
Received: from mjarzebo-mobl1.ger.corp.intel.com (HELO [10.245.244.171]) ([10.245.244.171])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 11:21:55 -0700
Message-ID: <b6b13ad22345bcdf43325173052614c17e803d00.camel@linux.intel.com>
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Maarten Lankhorst <dev@lankhorst.se>, David Hildenbrand
 <david@redhat.com>,  Lucas De Marchi <lucas.demarchi@intel.com>, Rodrigo
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
Date: Mon, 01 Sep 2025 20:21:49 +0200
In-Reply-To: <9c296c72-768e-4893-a099-a2882027f2b9@lankhorst.se>
References: <20250819114932.597600-5-dev@lankhorst.se>
	 <dc21e54c-d7ae-4d7e-9acb-6a3fa573b20f@redhat.com>
	 <9c296c72-768e-4893-a099-a2882027f2b9@lankhorst.se>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Stat-Signature: a1588kzqjzfrggq4yrjn1gxtohwakc4f
X-Rspam-User: 
X-Rspamd-Queue-Id: D3B6E1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1756750923-17524
X-HE-Meta: U2FsdGVkX18Dqk43jWAgfOkSKa8VrvFHUOtTntnrduMaTgRZFTv7QFbClLh8sNkvDmFZdHdCv/kzt5y0N1GHYCxoVGeT6H68vS2jk/O0HKy/GInO0usMBLZcoKvdhVhQ4QD8CWCrigK23Xe4vDBXgkn85XKE/XRHH5D8s3UrWTCTw5bOcpmxQp9DGKybRhtSOwsxDs7TjZCOt8C2el36OBVXyPyu02osJ+DeJIBAdRqk3GQd/k2R/OpwrqMwi4WcRLTXSyhxwUXOTMyywbgO2m5SPPxIeJYEvILiSlyxS+o/xuqGVkwLxM/to9suDqnuQF9rZ8Wqn6vvVVzAnGm+T1aBH/LbuGjLFybKO8ywgGo7HRWnDZEMHN7kniJfQk/k/JjBqJjf8qwuSsezfxjRHWTLjfI7Rvqfm0o2JFdeTLrZjmf3r2zdFs2R63nNJsVrg908gVX2BDCuY9E3x6LOLQiiT2MQtKa+YWhYy+Za5Rx3eel4IHVkcLsI6Zfwn5AjTZwoJ4xoP+YiEbGfgaiG/le1uhUTGtQ3kSpkJ4BpbIqYQnFB0d70vRaM6GHFYkPKA2EmwANa6zVow0U00JUL1pQmoOJzmqWnNhzVUfEzd9S9xTnI64ijG36rzak4OsDPLPIDyIhQ2OBo2+uiDQoDKX2EYcEDV8OIbDZAtbImWLDlGmnVlGunWaCHsV6R+tKFexuFBbSrzvgqwPvyqXvy2sP5qNNfjdGJTnVmPjNyfUW0/Qc4Ot3lIYeDCRdzPZwxia3mK6E6/f1xzzz5qQom+XnDVf1stR77lWSEMYaen6janmP7KexoK/PNTXjGlsrj2vpnA12DLFuxAhvJHcyV2XtcFA7CsEoMVCOmVSb6b/+XZOqbxnXFHjnrgzAO8HfnmKQOaLjsNZQxSCPuuVvrPgpgTkSldL04gc9JQ0OxkqfoQx29GprfTrWPgS1qU8ZGpwOw+pYNZDh0UylR1JG
 lGa5JDI+
 xFvzi9VPu7vqIOvbBis5aNmNhc0zM19QXHx9c2H+QQUK9mXspQoCtJbGHyWYwURSCAkq43LkDEml3Tevyj0iqnkOOFpm3ivBe1UNJaPMxThxElaGv76VeR9dwgyDycD14PsBI55hCFUkthGah+CTQ0aYyobZFyYbgRXWGNxCzSb3By4DwqkCJomwKCkAt4vpWvoaBHfWtIrWGEUwtGcwgDjkqwQrOEMpMpzgbzpsMv+XyMZc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, 2025-09-01 at 20:16 +0200, Maarten Lankhorst wrote:
> Hello David,
>=20
> Den 2025-09-01 kl. 14:25, skrev David Hildenbrand:
> > On 19.08.25 13:49, Maarten Lankhorst wrote:
> > > When exporting dma-bufs to other devices, even when it is allowed
> > > to use
> > > move_notify in some drivers, performance will degrade severely
> > > when
> > > eviction happens.
> > >=20
> > > A perticular example where this can happen is in a multi-card
> > > setup,
> > > where PCI-E peer-to-peer is used to prevent using access to
> > > system memory.
> > >=20
> > > If the buffer is evicted to system memory, not only the evicting
> > > GPU wher
> > > the buffer resided is affected, but it will also stall the GPU
> > > that is
> > > waiting on the buffer.
> > >=20
> > > It also makes sense for long running jobs not to be preempted by
> > > having
> > > its buffers evicted, so it will make sense to have the ability to
> > > pin
> > > from system memory too.
> > >=20
> > > This is dependant on patches by Dave Airlie, so it's not part of
> > > this
> > > series yet. But I'm planning on extending pinning to the memory
> > > cgroup
> > > controller in the future to handle this case.
> > >=20
> > > Implementation details:
> > >=20
> > > For each cgroup up until the root cgroup, the 'min' limit is
> > > checked
> > > against currently effectively pinned value. If the value will go
> > > above
> > > 'min', the pinning attempt is rejected.
> > >=20
> > > Pinned memory is handled slightly different and affects
> > > calculating
> > > effective min/low values. Pinned memory is subtracted from both,
> > > and needs to be added afterwards when calculating.
> >=20
> > The term "pinning" is overloaded, and frequently we refer to
> > pin_user_pages() and friends.
> >=20
> > So I'm wondering if there is an alternative term to describe what
> > you want to achieve.
> >=20
> > Is it something like "unevictable" ?
> It could be required to include a call pin_user_pages(), in case a
> process wants to pin=20
> from a user's address space to the gpu.
>=20
> It's not done yet, but it wouldn't surprise me if we want to include
> it in the future.
> Functionally it's similar to mlock() and related functions.
>=20
> Perhaps call it mlocked instead?

I was under the impression that mlocked() memory can be migrated to
other physical memory but not to swap? whereas pinned memory needs to
remain the exact same physical memory.

IMO "pinned" is pretty established within GPU drivers (dma-buf, TTM)
and essentially means the same as "pin" in "pin_user_pages", so
inventing a new name would probably cause even more confusion?

Thanks,
Thomas




>=20
> Kind regards,
> ~Maarten Lankhorst


