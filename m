Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DBD5ECD13DA
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 19:59:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E2C96B0088; Thu, 30 Apr 2026 15:59:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4942E6B008A; Thu, 30 Apr 2026 15:59:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 381BE6B008C; Thu, 30 Apr 2026 15:59:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2B9276B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:59:53 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AC7331401C4
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:59:52 +0000 (UTC)
X-FDA: 84716287824.18.9E4A1BF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.15])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8DC42A0002
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 19:59:49 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LgSKCJu7;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777579190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=slz8eTKsY4YDA50xQG0Q9MRcubgU+W/wvTmZpbUFzOw=;
	b=mfWZpE0n5TvH8ADxQlwiwKY/Wm2KvsoYA237teJIRjRwaV2WZ0/TPN3dpOzb0PWfdbX/9F
	35t3iMbjn7aq2OHoShqhzKraMXMVTgmiLnd9/thAbwnfNwCm17oUqcEdDX++X/f5pQTQS+
	3BghMZgEghSHmeNFzEDC2r3sSlbi4yk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=LgSKCJu7;
	spf=pass (imf25.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.15 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777579190; a=rsa-sha256;
	cv=none;
	b=pIqoDJC3FWsKDWzntQRqsbdMafF3QLlmGSiqDmRtKFYJnKlgdv32H+0C/MPfSaHPWHLZ7D
	/nOGGAOb1vArbnjYW/HcM0DZhG7I1I1yKwd5mWZ9D6LtukcHqfDixr1t5wyLQIrjB9kVWz
	xswPzJ8nJj86np2/DBh9SAzyNdI/uHc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777579190; x=1809115190;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=slz8eTKsY4YDA50xQG0Q9MRcubgU+W/wvTmZpbUFzOw=;
  b=LgSKCJu7tkHficlBEPQBmye5dIG157o3qiPciSKI0JdKelp4f2ECbHPM
   Ckl6tEk+a/vIW3QFpqADFpghD+r9Qh7BqXlIVJWFAUwvaDrUNJW85/lUP
   ljp26d+O0Nn6PivbsS++edQSLUYMuEHVFrMM5oH5/jmzFAsFsLgy9C0Q9
   VdRU2RmQVo06zs1jRdlguhSOO2OXgXWLW1PIViGg5hB5nOVmz3iyfLsUQ
   h6VI39P556MOXT84ASNjs8++Euhhy4nYyc1NlZOZHoXCDHcwuBPTheGI0
   XyFD0f3ufat3MljB0CMmxOFQYQiLRsc0vimUSdy1wFzwkizicI0HpiJvP
   A==;
X-CSE-ConnectionGUID: 2eLpsSqeS2aeXBNH+93ImA==
X-CSE-MsgGUID: 0HLdYQCHQ1yTCL2c6Xhvwg==
X-IronPort-AV: E=McAfee;i="6800,10657,11772"; a="82148636"
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="82148636"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by orvoesa107.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:59:49 -0700
X-CSE-ConnectionGUID: /q/sqexoSfWOFfrF7fdhDg==
X-CSE-MsgGUID: /+zgkXZdQO29g+P0S15dqQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,208,1770624000"; 
   d="scan'208";a="232024909"
Received: from dalessan-mobl3.ger.corp.intel.com (HELO [10.245.244.73]) ([10.245.244.73])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 12:59:45 -0700
Message-ID: <4ebeb470d5ab495f5d5342454db57b1a6ccc4753.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Andrew
 Morton	 <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 30 Apr 2026 21:59:43 +0200
In-Reply-To: <afOEqOZVWi/cNf9g@gsse-cloud1.jf.intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
	 <20260423055656.1696379-2-matthew.brost@intel.com>
	 <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
	 <be42059924cde9bb16a087ee2a5abb0b9d850d68.camel@linux.intel.com>
	 <aepuNL2fwp47P1Wi@gsse-cloud1.jf.intel.com>
	 <aeqbe/9YRKNyYuWY@gsse-cloud1.jf.intel.com>
	 <291406b26b8badf2e565996515931d9ebe50208f.camel@linux.intel.com>
	 <a1252167-63a1-481b-9f1d-2a7bae7a3b6c@kernel.org>
	 <afLCwHaPZMu/dxqY@gsse-cloud1.jf.intel.com>
	 <f4324084f3808b9a42b87ec27bef7fe920dde9ea.camel@linux.intel.com>
	 <afOEqOZVWi/cNf9g@gsse-cloud1.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8DC42A0002
X-Stat-Signature: fxhpxxj1t9ga1xgcjts6fxtgoyhr36t1
X-HE-Tag: 1777579189-787528
X-HE-Meta: U2FsdGVkX184MuVSj9+cp4Lb1THkeU8e0WGjK7MVPG2lV/q8JOS31KJrLpt7pV3KkknmaOOmepvm4g2zesPGNjn1J8MYAPYndYjOC4DJMioDKX+3axaxckq5KjuQ8UKDaBGiMwBfb/eYwmdaTsJxPscPRWLIswN8jLCnu1LXSBJLGm8SUGDUyYesXJ0xmq2Kz4Z9Kk8igTIoqnPhovbzVlsvrC/xLPJlaIESDzn/oE+C1VNgXn0iUJbKJoc1mUn3N+3qrAv6pVJ2C4URnwoZXAShdFufP6bpAyEGKegQ95DYr/Abemw158nsBYVq4GCe27yluBy3fvJiy3TrvZtSMeWumnfoYJXhxoxp5n3iTn84nxwh0YV44eMXXU53oEodx/B2tm76QaDBItgEmgit8Sc9mcjOqoqq/jE/06pKcV9VeXMPm1/9gaUuwiMvmlmvxFg4189c2Rr6fwV9Gxqghyn72TWzOJytLGibBPC9JLW+9dWa2q7+KyZDIy7NEXMaKzuUfyKW2q5RCGIqXfp7d9duZxoTxTUK7ThFUxna73sV4Cm6av7tZtXT6OVcNP5ZI487RGxNej0Tuo+cKfB1XAZYyGLxNtlLygJ4KPSSXF45oJWrUWFLQI8GZ9G1S29pK2cB985ZUKF5zy/gyDZNtiGVpU1jVpWV9IPw+yHObXQpSNTwOlSXyKMCIy+FpI/3a9cGZQUUbLSZAx8OcH28bJWwGwrt8XpysdZC99wkB725qPBh09wXjofitRV5JU6EMNScFa1zrK82fycGHLaDk9pSidMivwOrqQ4YPvFDG4OCcOdab6irgsWAk6ymIfyIzfiqCajpscemTXXSs8isQsJG+YboZagEFmY7RVoNDSMYiUCCSvQQUINh8DmOCjVfLCkClsUe29OR6ds4gR7UKzm4Hi5jZHUSz7Fs24KQNduQ8bhyEGgAcIqvPleIfQFVcTYKwql2ca9DHmzOy9G
 osrVeKok
 +jc9eTG3NW615NPzpv1nyiL+msdARWKWJClJavZ/hXjoXJvlbR9ru0NpartrlHu+mdfnkyKy4MbPBS4uh+gtrGW+xl+mWPUOtr0bWVzUlugU9XmFkSfKo4nIW56+naVfFT3Evajo6LFVZhhPgjwCQP5LTKrbAi0YAIvmSmYuIdPSHhVr5vQeaMhCy0ECSU9EqmRXnek1iJqscwB05Q6CjaGPxwmDJfPgyO0xzoxd3pGyw5LpeQPkV1H2BJNjMhRJEkoQ9HlyAyQmy9JNZCXGRqfamuWysnhQVm1Z8l0HBwH9LLzdX9A48i1fyFm2ESgKKZiXzM4rHb7qEEJAhliGtSH2y2abpNjZT+6I7ThEQY64s3Dk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-04-30 at 09:34 -0700, Matthew Brost wrote:
> On Thu, Apr 30, 2026 at 09:47:37AM +0200, Thomas Hellstr=C3=B6m wrote:
> > On Wed, 2026-04-29 at 19:47 -0700, Matthew Brost wrote:
> > > On Fri, Apr 24, 2026 at 09:26:18AM +0200, David Hildenbrand (Arm)
> > > wrote:
> > > > On 4/24/26 09:05, Thomas Hellstr=C3=B6m wrote:
> > > > > On Thu, 2026-04-23 at 15:21 -0700, Matthew Brost wrote:
> > > > > > On Thu, Apr 23, 2026 at 12:08:36PM -0700, Matthew Brost
> > > > > > wrote:
> > > > > > >=20
> > > > > > > If the order were included in shrink_control, there is
> > > > > > > about
> > > > > > > a 95%
> > > > > > > certain that this change would allow TTM / Xe to break
> > > > > > > the
> > > > > > > problematic
> > > > > > > kswapd feedback loop. This may also better express the
> > > > > > > intent
> > > > > > > of
> > > > > > > the
> > > > > > > problem we are trying to fix here.
> > > > > > >=20
> > > > > > > For reference, the cover letter [1] details the problem.
> > > > > > >=20
> > > > > > > Any guidance from the core MM folks would be
> > > > > > > appreciated=E2=80=94would
> > > > > > > adding
> > > > > > > the order to shrink_control be an acceptable solution?
> > > > > > >=20
> > > > > > > Matt
> > > > > > >=20
> > > > > > > [1] https://patchwork.freedesktop.org/series/165330/
> > > > > > >=20
> > > > > >=20
> > > > > > It doesn't look like __GFP_NORETRY, __GFP_RETRY_MAYFAIL,
> > > > > > __GFP_NOFAIL
> > > > > > make it to the sc->gfp_mask flags from the caller and get
> > > > > > into
> > > > > > kswapd
> > > > > > loop...
> > > > >=20
> > > > > Perhaps that's because they mostly (only?) make sense from
> > > > > direct
> > > > > reclaim? Looks like the trace is from kswapd.
> > > >=20
> > > > kswap obtains the desired order through pgdat->kswapd_order, as
> > > > a
> > > > hint from
> > > > allocation code (wakeup_kswapd). The order can be easily merged
> > > > (just use the max)
> > > >=20
> > >=20
> > > Yes.
> > >=20
> > > My current thinking is wire the order into shrink_control as that
> > > is
> > > quite straight forward + only call this helper + short circuit
> > > shrinker
> > > on higher orders.
> > >=20
> > > > We do have the gfp_flags there, but merging them from different
> > > > wakeups is a bit
> > > > more tricky (and when to reset?).
> > > >=20
> > > > Assume we have one urgent request for order-0 and one non-
> > > > urgent
> > > > (noretry,nofail, ...) request for order-9, we'd have to figure
> > > > out
> > > > a way how to
> > > > represent that. Gets more complicated for more orders.
> > > >=20
> > > > Of course, we could have some kind of array, and try to store
> > > > some
> > > > "priority"
> > > > per order. But I assume plumbing that into the rest of kswapd
> > > > might
> > > > not be that
> > > > easy.
> > >=20
> > > Yes, this seems non-trivial. I was also on a call with Google
> > > today
> > > discussing what Android (client Linux) would like from shrinking,
> > > and
> > > my
> > > initial feeling is that we will need to do some surgery to the
> > > shrinker
> > > core and GPU shrinkers to make all of this work well over the
> > > next
> > > year
> > > or so.
> > >=20
> > > So again, I think starting with wiring order into shrink_control
> > > and
> > > this helper is a good place to start, as it fixes an immediate
> > > issue.
> > >=20
> > > Let me know if that seems like a reasonable direction.
> >=20
> > +1 for wiring order into shrink_control, and possibly also the
> > priority
> > as mentioned in an earlier email.
> >=20
>=20
> Let me look at how priority field is used as well.
>=20
> > However for cgroups-aware shrinkers, The number of free memory in a
> > zone might not be an indication of fragmentation-triggered reclaim
> > at
> > all, it could be the result of the cgroup hitting its memory
> > limits.
> >=20
>=20
> I agree for cgroups what is in place here is not sufficent and based
> Google's feedback of every user space in Andriod is assigned a cgroup
> so
> we will quickly need a cgroup story.
>=20
> > So I think if we can solve this with a combination of GFP flags,
> > plumbed-through order and plumbed-through priority, that would be
> > ideal.
>=20
> That is an idea. The other thing that came up is TTM LRU doesn't
> understand relavence of hotness compared to other shrinkers LRUs
> (e.g.,
> core pages) so our TTM shrinker may be evicting hot GPU pages while
> cold
> non-GPU pages could be evicted which would create less stress on the
> system. Perhaps priority / GFP flags will help here?

IIRC priority is used to calculate how many pages we are requested to
shrink compared to the number we say we have available, but that needs
to be double-checked. FWIW i915 has a check that xe's shrinker lacks,
that shrinking is not attempted unless the number of pages requested is
>=3D an average buffer object size.

/Thomas





>=20
> Matt
>=20
> >=20
> > Thanks,
> > Thomas
> >=20
> > >=20
> > > Matt
> > >=20
> > > >=20
> > > >=20
> > > > --=20
> > > > Cheers,
> > > >=20
> > > > David

