Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5B5BCA0FF0
	for <linux-mm@archiver.kernel.org>; Mon,  1 Sep 2025 14:39:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52EF88E0069; Mon,  1 Sep 2025 10:38:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 507028E001A; Mon,  1 Sep 2025 10:38:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4219C8E0069; Mon,  1 Sep 2025 10:38:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 28D938E001A
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 10:38:12 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C755F13B105
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:38:11 +0000 (UTC)
X-FDA: 83840936382.21.8953F83
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.8])
	by imf21.hostedemail.com (Postfix) with ESMTP id 208491C0002
	for <linux-mm@kvack.org>; Mon,  1 Sep 2025 14:38:08 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gfIWM0WK;
	spf=none (imf21.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.8) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756737489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WQNkr5EKb/5FuHLMhuxLTbLlrHHNbuV0X7itYDSvCTo=;
	b=TqvRKqGChKZPzBO7QLQbLAPud0awByqyFBoy8Ab6HPsdUSTfGpqSse127ERcIuR5cufhk+
	W2NNZbpDq9e3GBc0LdqFqUDsqrkC0b2GY4L24+xTiWrTaYIssN4OtH0T8101LmsBrafuSW
	iE5WuM9s3r8xVMwbBrsoQugm9PIgw8w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756737489; a=rsa-sha256;
	cv=none;
	b=CdvhVRY00SpqnhSqOXpfaW3OEtMo3/9Z9kbozLUM2iKXmb5bO02SLEB8YJvRH6oAXBzHin
	A4mNZRun893MTyJ5iwo/rdnNwECkaAUSzTVrpr4ARlnG0Myx+di73QJCGHUbgd9vm0L7b7
	cEVCFFYtMIhklLl1hPU/O7JuRfi6lkk=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gfIWM0WK;
	spf=none (imf21.hostedemail.com: domain of thomas.hellstrom@linux.intel.com has no SPF policy when checking 192.198.163.8) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1756737489; x=1788273489;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=WQNkr5EKb/5FuHLMhuxLTbLlrHHNbuV0X7itYDSvCTo=;
  b=gfIWM0WKGBtFugoxH1NTQBgp5oI51wkl130/ge4hmCD++bmXe2EkEs8A
   n40ofuPm7eZR+zJTHoeKML1PGEVr6D26TL8MFikJQUYJSjsA4NUo+jhI9
   Ywd5+gdmMY/XUfAqS6mfvDOt1zPOWiyzjTxDDAcIu6zwRlOkdI4TOkcqj
   6VLfXP2PmAdz6Snl/ntXQbVA7pDKmhs74zEJ1dUqo+HGWr756HK0cBoDp
   aQ51YvXX2dvXVb+R8LjwdhUKiZeLZm/4y08jv23DXjFX2HZtE1DO4MhS9
   EW0imoj4FGXB+oocqs/SZVsU0nnoRDtF03bwHqd2htI7mC2zTG+SXH9co
   A==;
X-CSE-ConnectionGUID: xKLdSTc/SQyYDfZJ1bxN0g==
X-CSE-MsgGUID: QHNAEMgCShSsj/RWiyWcVQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11540"; a="76595899"
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="76595899"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by fmvoesa102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 07:38:04 -0700
X-CSE-ConnectionGUID: FKyLHvmdRWK5frmJXgJzRQ==
X-CSE-MsgGUID: TmZPTmE/S+a9W82GyBX+0g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.18,225,1751266800"; 
   d="scan'208";a="170590896"
Received: from mjarzebo-mobl1.ger.corp.intel.com (HELO [10.245.244.171]) ([10.245.244.171])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2025 07:37:56 -0700
Message-ID: <3713e6d83421fcf64978927a1cb40fae1e3c7a57.camel@linux.intel.com>
Subject: Re: [RFC 0/3] cgroups: Add support for pinned device memory
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Natalie Vock <natalie.vock@gmx.de>, Maarten Lankhorst
 <dev@lankhorst.se>,  Lucas De Marchi <lucas.demarchi@intel.com>, Rodrigo
 Vivi <rodrigo.vivi@intel.com>, David Airlie <airlied@gmail.com>,  Simona
 Vetter <simona@ffwll.ch>, Maxime Ripard <mripard@kernel.org>, Tejun Heo
 <tj@kernel.org>, Johannes Weiner	 <hannes@cmpxchg.org>, 'Michal
 =?ISO-8859-1?Q?Koutn=FD=27?= <mkoutny@suse.com>,  Michal Hocko
 <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel
 Butt	 <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, Andrew
 Morton	 <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "'Liam R . Howlett'"
 <Liam.Howlett@oracle.com>,  Vlastimil Babka	 <vbabka@suse.cz>, Mike
 Rapoport <rppt@kernel.org>, Suren Baghdasaryan	 <surenb@google.com>, Thomas
 Zimmermann <tzimmermann@suse.de>
Cc: Michal Hocko <mhocko@suse.com>, intel-xe@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Date: Mon, 01 Sep 2025 16:37:51 +0200
In-Reply-To: <25b42c8e-7233-4121-b253-e044e022b327@gmx.de>
References: <20250819114932.597600-5-dev@lankhorst.se>
	 <25b42c8e-7233-4121-b253-e044e022b327@gmx.de>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
MIME-Version: 1.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 208491C0002
X-Stat-Signature: srhwfyqgyo7mpobwzx65rs5somhe5mwn
X-Rspam-User: 
X-HE-Tag: 1756737488-198246
X-HE-Meta: U2FsdGVkX1/3FwPLG53ifviJ1lm2toYHqDnKtXGP1avf/++PkVx5QtkCvXqcFrp+miZonas26TyclnmwvZDnMUx+9MgT1hgxpbK5iBduc7fVFmQ2maF91vkFrEi+fnmbKbj3Jden8nAYA+msLeG+LS2KKxouHyv36GxvUpn+3bFEJCHTnwr3pi7RJyOTEuHZX3TMZjfKSGxQFbzFMNrC2MkbtBPeR+/a2wFd0kWnmJ/N02B68Qzj5KwsKYs+t3MH2pf9cTHUdrauf6UdXAQYR8Z5O8tufI/t5oqZ9jiVPh0M54HzyA59U6oFk9UisbvROaH4uE8ITKfZQmQ4BpINp3B2C/eENZtaNU3RESkFz6WOa2TxJD0f80H//3uwoh46dXmrNjBu1oIBUiUUwkHk9M6uUR22ST9bwmee4dUFBuTIdYEW8k3B2tNm9ciltTF7b1cEvHuZd3bCWCiCV6ou7zjH2wEO4GeRKWapvLu97rqA0qTlGERS7LvegwxTdI2KwS0EyGMgetSsjmp874KqI+50whfZ32nVBMT58eDne+vMFtvnEhMxfSLi6BXdO1FjUYLPx7kF27FHuH+LW6pnrw1YjgADmPkoDGjTVHZ7wz5w2MBX+oXz3GKkVdAfiUYtoO0K2U53Ac/Fqki3xcihSytP14HppxWZ1qFl5qgXo23w4GAxANASyz4JFcSggMY2sk+XJhF6mTBEOm/o0QPCWjc75OU/5OGMS6RXZi4si70t7SCLVJKvzg6mtVkNzvXSTbF1AGYoCVLghzayDdT2wRQ6J5vhYQybud4mWXilTFKdIlJJr6hfJ88HNxjxYOj3kjDwZFZR/mcT70ilj/lKwdnIYsoa2CxD1xtCq2gsI14=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, 2025-09-01 at 14:45 +0200, Natalie Vock wrote:
> Hi,
>=20
> On 8/19/25 13:49, Maarten Lankhorst wrote:
> > When exporting dma-bufs to other devices, even when it is allowed
> > to use
> > move_notify in some drivers, performance will degrade severely when
> > eviction happens.
> >=20
> > A perticular example where this can happen is in a multi-card
> > setup,
> > where PCI-E peer-to-peer is used to prevent using access to system
> > memory.
> >=20
> > If the buffer is evicted to system memory, not only the evicting
> > GPU wher
> > the buffer resided is affected, but it will also stall the GPU that
> > is
> > waiting on the buffer.
> >=20
> > It also makes sense for long running jobs not to be preempted by
> > having
> > its buffers evicted, so it will make sense to have the ability to
> > pin
> > from system memory too.
> >=20
> > This is dependant on patches by Dave Airlie, so it's not part of
> > this
> > series yet. But I'm planning on extending pinning to the memory
> > cgroup
> > controller in the future to handle this case.
> >=20
> > Implementation details:
> >=20
> > For each cgroup up until the root cgroup, the 'min' limit is
> > checked
> > against currently effectively pinned value. If the value will go
> > above
> > 'min', the pinning attempt is rejected.
>=20
> Why do you want to reject pins in this case? What happens in desktop=20
> usecases (e.g. PRIME buffer sharing)? AFAIU, you kind of need to be
> able=20
> to pin buffers and export them to other devices for that whole thing
> to=20
> work, right? If the user doesn't explicitly set a min value, wouldn't
> the value being zero mean any pins will be rejected (and thus PRIME=20
> would break)?

That's really the point. If an unprivileged malicious process is
allowed to pin arbitrary amounts of memory, thats a DOS vector.

However drivers that allow unlimited pinning today need to take care
when implementing restrictions to avoid regressions. Like perhaps
adding this behind a config option.

That said, IMO dma-buf clients should implement move_notify() whenever
possible to provide an option to avoid pinning unless necessary.

/Thomas



>=20
> If your objective is to prevent pinned buffers from being evicted,=20
> perhaps you could instead make TTM try to avoid evicting pinned
> buffers=20
> and prefer unpinned buffers as long as there are unpinned buffers to=20
> evict? As long as the total amount of pinned memory stays below min,
> no=20
> pinned buffers should get evicted with that either.


>=20
> Best,
> Natalie
>=20
> >=20
> > Pinned memory is handled slightly different and affects calculating
> > effective min/low values. Pinned memory is subtracted from both,
> > and needs to be added afterwards when calculating.
> >=20
> > This is because increasing the amount of pinned memory, the amount
> > of
> > free min/low memory decreases for all cgroups that are part of the
> > hierarchy.
> >=20
> > Maarten Lankhorst (3):
> > =C2=A0=C2=A0 page_counter: Allow for pinning some amount of memory
> > =C2=A0=C2=A0 cgroup/dmem: Implement pinning device memory
> > =C2=A0=C2=A0 drm/xe: Add DRM_XE_GEM_CREATE_FLAG_PINNED flag and
> > implementation
> >=20
> > =C2=A0 drivers/gpu/drm/xe/xe_bo.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 66 ++=
+++++++++++++++++++-
> > =C2=A0 drivers/gpu/drm/xe/xe_dma_buf.c | 10 +++-
> > =C2=A0 include/linux/cgroup_dmem.h=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +
> > =C2=A0 include/linux/page_counter.h=C2=A0=C2=A0=C2=A0 |=C2=A0 8 +++
> > =C2=A0 include/uapi/drm/xe_drm.h=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | =
10 +++-
> > =C2=A0 kernel/cgroup/dmem.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 | 57 ++++++++++++++++++-
> > =C2=A0 mm/page_counter.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 | 98
> > ++++++++++++++++++++++++++++++---
> > =C2=A0 7 files changed, 237 insertions(+), 14 deletions(-)
> >=20
>=20


