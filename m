Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CEEBEFCE42
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 20:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 22EF56B0005; Wed,  4 Mar 2026 15:06:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1DC586B0088; Wed,  4 Mar 2026 15:06:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E8956B0089; Wed,  4 Mar 2026 15:06:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EF13C6B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 15:06:32 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9A7A514067E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:06:32 +0000 (UTC)
X-FDA: 84509463024.18.3AF48F8
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2782FC000A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 20:06:28 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JgHV3429;
	spf=pass (imf22.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772654789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YjHQ0Iu/HvT6+/OF/ZjRkwFboR6C1zmMJpCB9HqJRQw=;
	b=fn9JRW/F0yVjhtRutxN1Ze/9vboT+Jz5d11ltlq9fJqB4i/DRwaS7VMLEM+APycVqGub+c
	cIs4T6hzF3puYR14hoUqZlRNPqKhDnTH+TNs6uZsJ6B6mPi/nA0LooHx9b8fOm3BJX9FAv
	Ro8RyPyV9uhqrnoY6lZEmvPoss2IM0U=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772654789; a=rsa-sha256;
	cv=none;
	b=rRyE87q8l8ty32n3YFESbvgld+Ck2cSLWJs5dpWMJd3PuCOX11/dG3sLieRTVnpS4VPAeg
	HCLuxRWw60QwNSYJ6Nt5nTcraQsQrBP0vv5Z6T7iid5NB9TcOGliY8qHjafD5qvl1XjX7Q
	vTMdJVpnK52t4vQBMmx/MXS4iisH4Bo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=JgHV3429;
	spf=pass (imf22.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.12 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772654789; x=1804190789;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=YjHQ0Iu/HvT6+/OF/ZjRkwFboR6C1zmMJpCB9HqJRQw=;
  b=JgHV3429Wg2PlizYeU+ANdm6OpCVsThjSl1ACR/1mRvTdvhMkbSqV8Fi
   Gfj/WnrGVVfuBhRAqri+R0IGWue67WV31VHNS/xVEdVOtNWpVqef7xa2U
   BwVBiU5CSPSVlkcTpPxo8w0fH6uzP3UTaS9j2NgMYDeCuX0m66aeIPUcA
   K01ESwFuTEwadvk+AIMIWAzp9WYyKRkhrV9iE1zYyHH5M17C80B9aHIz0
   sMN3zIzA6bDH6vQECy5fVb/aQIf5kkHb/B3UemU2dGleG2QQ8IOd52OXS
   doLaevpzC8YLKCtkNDevUA7PnTH75hB0IP886RGXHmALbPu6NMn7VRa7z
   A==;
X-CSE-ConnectionGUID: GbNkHOA1RWSACitFKwzCjQ==
X-CSE-MsgGUID: atH2hMzYT+OiZg747uwCKw==
X-IronPort-AV: E=McAfee;i="6800,10657,11719"; a="85199090"
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="85199090"
Received: from orviesa010.jf.intel.com ([10.64.159.150])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 12:06:26 -0800
X-CSE-ConnectionGUID: VUSTvsphSBy/o93IyD6Yfw==
X-CSE-MsgGUID: KnN07GWQTbKsjLEmGuH2bw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,324,1763452800"; 
   d="scan'208";a="217680838"
Received: from abityuts-desk.ger.corp.intel.com (HELO [10.245.245.170]) ([10.245.245.170])
  by orviesa010-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 04 Mar 2026 12:06:22 -0800
Message-ID: <756d0e9d67750f2c7c46baba3763d692d8778f3a.camel@linux.intel.com>
Subject: Re: [PATCH v3 1/4] mm/mmu_notifier: Allow two-pass struct
 mmu_interval_notifiers
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	intel-xe@lists.freedesktop.org
Cc: Jason Gunthorpe <jgg@ziepe.ca>, Andrew Morton
 <akpm@linux-foundation.org>,  Simona Vetter <simona.vetter@ffwll.ch>, Dave
 Airlie <airlied@gmail.com>, Alistair Popple <apopple@nvidia.com>, 
	dri-devel@lists.freedesktop.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Matthew Brost <matthew.brost@intel.com>, 
 Christian =?ISO-8859-1?Q?K=F6nig?=	 <christian.koenig@amd.com>
Date: Wed, 04 Mar 2026 21:06:19 +0100
In-Reply-To: <07fb6811-68fe-4cb9-95e5-ded58a082493@kernel.org>
References: <20260303133409.11609-1-thomas.hellstrom@linux.intel.com>
	 <20260303133409.11609-2-thomas.hellstrom@linux.intel.com>
	 <07fb6811-68fe-4cb9-95e5-ded58a082493@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: ywxj9djfpr6u1a67ro87z6bmgktdxcsf
X-Rspam-User: 
X-Rspamd-Queue-Id: 2782FC000A
X-Rspamd-Server: rspam12
X-HE-Tag: 1772654788-905956
X-HE-Meta: U2FsdGVkX19q2gJYusARPpgECrV7RLvKd19oJehdFx+4ZWU73+TykxzuR+NTnHK0q/9EfKGwmQX/rYN7XNGXardGbkVknpXnJhBgShIsupDACc+2tjHrR4XsBcu7+/5J8or5+B9r3psht1Lpjdz100RuY8F9G7725z1MHN6873jjndFnk2r3M0q6j/AhP5JTEgidoJMJ0GBXgDONqwwtJEm1RIFVN/3qVR3kJpOm+a4ogjcpkKII3fgfDoRfIPHKU19snLH0xVICSx8fx/U+6+0UGO7sO71yq/cR1L48Mpny5ef3ve/AXNzLaYniUwOaVNTycfeku23U/RimAa61NftZA0reIfU/I5Xz21qgiuYztu1IfhZ9Y4/Aru68zumKLZ4KcQIC17G0AW91qq1T+/u89yC77+pBsw+LzQ7QvbZvnxZmBoy+LLBqIlShSfvRd9StiZD5cTLlZM127zfJzE+yMAQx4SM+J18DyBPwo+s8LmUZnlJT8C6CxgBjFl08E5EJ3rDAKIkCIedQF3hstx3nTJPr56Yz/oFADbHjRO6B8/i6N3vddt1DcAGcVdXLhLcmXY5dgvDxFKDp/P5ZTC54hkOnZJlbqSfik7zhsqPFwmURIufCCOLRdIEsg9WxsVZ7fWdqzFYhDWQ1lit14fbCtDEydXmEhNGakpBmBbzUqPEI1p+AZEqCxH+w8OIkAPcVO1FybzKf8rwFMUB3q0Qtm/h5k2f6gL7dYeRlLhgZ9jw/IXm0RqbBcLufQgrIZeDdGmTIyZBv6nJMwC9kJ39/wUit2/ptyCtqJoP/mTT0/v5ENXB8ktyHiKHLpsceOEjnhjbbdS7ugH6LsenJeppGD/op6AWLePcoU6OAwGZlUl5fzZDasj11CVo4Wplqs1SEk4u4moVK1JhrzzqOE8UZGIOCfLHlsCcMrj8B/rvlQYc8eCa49X6NoDtJlSssoSuHgZo3PUyscaMMSkO
 Nc3NKOzG
 sjffSX5ovaTNvxF6C8n5UBzNMS1Y+yqj4ukn7GWD31+/gGhaq4j/uuOG/1VLqpYsVMoaJ4uZbMZ7dzMcbUwTIfRKKjN9Um+uZ7LjZLHTV9UGYOpXXRmuxJcHChB4RuAovs7XLyWrNOR+R1KfB3vXrZCBtJmeVLGBmVUizRKs6nn0jK2wzqvy4mYv7Mu+rpuImUVOJLz/tW4ZbM+L6nvsm7hkeh3vmJ2YD5dZumWDEbydwLJGopL0nLUW6WTC3sTSt4sVi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-03-04 at 20:32 +0100, David Hildenbrand (Arm) wrote:
> On 3/3/26 14:34, Thomas Hellstr=C3=B6m wrote:
> > GPU use-cases for mmu_interval_notifiers with hmm often involve
> > starting a gpu operation and then waiting for it to complete.
> > These operations are typically context preemption or TLB flushing.
> >=20
> > With single-pass notifiers per GPU this doesn't scale in
> > multi-gpu scenarios. In those scenarios we'd want to first start
> > preemption- or TLB flushing on all GPUs and as a second pass wait
> > for them to complete.
> >=20
> > One can do this on per-driver basis multiplexing per-driver
> > notifiers but that would mean sharing the notifier "user" lock
> > across all GPUs and that doesn't scale well either, so adding
> > support
> > for multi-pass in the core appears to be the right choice.
> >=20
> > Implement two-pass capability in the mmu_interval_notifier. Use a
> > linked list for the final passes to minimize the impact for
> > use-cases that don't need the multi-pass functionality by avoiding
> > a second interval tree walk, and to be able to easily pass data
> > between the two passes.
>=20
> Please CC all maintainers+reviewers that MAINTAINERS recommends you
> to cc.


Hmm. Good point. I missed a fair number of those.

Will Resend
Thanks,

Thomas

