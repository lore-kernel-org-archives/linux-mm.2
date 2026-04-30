Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2623CD13D3
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 07:47:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0BEC06B0088; Thu, 30 Apr 2026 03:47:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0706E6B008A; Thu, 30 Apr 2026 03:47:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA10F6B008C; Thu, 30 Apr 2026 03:47:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D511D6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 03:47:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71A00401B6
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:47:51 +0000 (UTC)
X-FDA: 84714443142.12.09AAFEF
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.16])
	by imf20.hostedemail.com (Postfix) with ESMTP id B56361C0011
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 07:47:48 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m7YlYiyo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777535269;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rrjCU3x04b/m/KmStz9/897b7XAGRr3pleBMtTv//wk=;
	b=WWjOPIXfjkiH8V+g12O8ddo3Smag8RSLGX/4yZcYb19i9Srik8dfr4F6GIH6ra2K2D5Q6h
	Mwyj5jGIgmNez5xdePj1s0uia1Ku4UNTwwuyzOg7gq2JbObOGgN79+bzFHiRs6o/zAqKyt
	lwmb5dUfyBoUlqMve0xh8P+ckrt+yHY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777535269; a=rsa-sha256;
	cv=none;
	b=viXqDR9thPUwb4eBYeZkcyZHCxO7W0WXlHToS6s/SP359llwP3okXr/a6OBDwvOqqEwNpU
	EgRCJGTcRaHWEN7MhnpRZLo5Wm5GwWQlJgaL/pb50lElJ/buTV2zkdT1mEZpM1R507o/D/
	3XF4wiOnsv+9xv/w17YsVAQWamYNmpo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=m7YlYiyo;
	dmarc=pass (policy=none) header.from=intel.com;
	spf=pass (imf20.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 198.175.65.16 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777535269; x=1809071269;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=rrjCU3x04b/m/KmStz9/897b7XAGRr3pleBMtTv//wk=;
  b=m7YlYiyoUCP/+vQwoMJPVn0QnwglVOlaflHhDsJb+5M+VK8HXph9lI9x
   9Luyc4pZJCJEf9igp7PBKFSZ2bf7NkjI9ZbvYc2tnCAackRZPpJyHfoMO
   fyter+UPQcSCsfoW3GENUec1CyQ30lR4WJgomCUoggA7LwhhsUp3S1Wy+
   6zvDEImPRZl1vo04npDzz7r9kgCj8UheKsfAM9lA0KoOME0IR2C8Y+f6a
   SRo93n0WJIrHHkLPwqz4hiiEpXlHAAoLeUNQdUe90dwMKt65fzdFbKK8/
   QongOWSVg6SJiyxSaQZBwP38IwOo+1cPrv42HfY0YtjttScPIu+JokRZR
   g==;
X-CSE-ConnectionGUID: LT4/2OdwSyKk8FKZZtNcxA==
X-CSE-MsgGUID: WBcUyi97QuKCEAPAX5Jbfg==
X-IronPort-AV: E=McAfee;i="6800,10657,11771"; a="78668539"
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="78668539"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by orvoesa108.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 00:47:47 -0700
X-CSE-ConnectionGUID: hK+Q8UH0ShiRZenYTP9eTQ==
X-CSE-MsgGUID: YSJGkPeBQfaiTuXiiKoUDw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,207,1770624000"; 
   d="scan'208";a="238833611"
Received: from dalessan-mobl3.ger.corp.intel.com (HELO [10.245.244.73]) ([10.245.244.73])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Apr 2026 00:47:40 -0700
Message-ID: <f4324084f3808b9a42b87ec27bef7fe920dde9ea.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: Matthew Brost <matthew.brost@intel.com>, "David Hildenbrand (Arm)"
	 <david@kernel.org>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org, Andrew
 Morton <akpm@linux-foundation.org>, Lorenzo Stoakes <ljs@kernel.org>, "Liam
 R. Howlett"	 <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@kernel.org>, Mike Rapoport	 <rppt@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, Michal Hocko	 <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>
Date: Thu, 30 Apr 2026 09:47:37 +0200
In-Reply-To: <afLCwHaPZMu/dxqY@gsse-cloud1.jf.intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
	 <20260423055656.1696379-2-matthew.brost@intel.com>
	 <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
	 <be42059924cde9bb16a087ee2a5abb0b9d850d68.camel@linux.intel.com>
	 <aepuNL2fwp47P1Wi@gsse-cloud1.jf.intel.com>
	 <aeqbe/9YRKNyYuWY@gsse-cloud1.jf.intel.com>
	 <291406b26b8badf2e565996515931d9ebe50208f.camel@linux.intel.com>
	 <a1252167-63a1-481b-9f1d-2a7bae7a3b6c@kernel.org>
	 <afLCwHaPZMu/dxqY@gsse-cloud1.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Rspam-User: 
X-Rspamd-Queue-Id: B56361C0011
X-Rspamd-Server: rspam04
X-Stat-Signature: sqjued4b6er1cgtu8umndr37k6my8dat
X-HE-Tag: 1777535268-111357
X-HE-Meta: U2FsdGVkX19Xgk28DSvaSVHrs/5w6UgS3NfzZuhSRfxJS9Cvp29+lnaPRHl7oOTw5lgyCJCo50z0fjNGSOw1JHdNP/C3xE8qWI4AMeB5qvy85MzdXxPYXLtbBiWm8LytpMR1ZsZfOdspAfik5BZFGWiERdRPZSnUPFUV0DJpdYwH51sEpnkXnq1w0qWcFuAZHywRSCVn1+I9S0uJM969f+/Q2b1xpnHVGqVbcgBjjzED1XXjdCPqyLbkexOQRdui9ngCYc1tND5H1fWPjF8UrUiUAuBjMo8UnObLGuf9aw4b3uOSB3Kse4ZWT8RwtIx6T/soMJwsbk9g52scoVq4f5sREu1lae8JqUWUCmHpOcHfgnmlOpRcGgMHNbrNjBh3LhY4wIAV0klnfqaAa5oX/L9hU5+kuceemy+7+2kEE/Y71XxMk/E7YP1kVvp0Rh5Dp2Y7l47ZQj0c/rH6U/4tPVwQLT4psKBMXmJrJcjdHwu96aXS7R2xwLuN5KHYe9exjRPMDgiSbLyJ3q7IFmQCVaQyC/8YDyVIjrkQApCD9bmeP+VhCsxJEGHN4oW0Nw35PBCTwwar89xuodAtdh525bY7ZevJUVmhv3hBArUM8h0V6Mq+uI09NH01gf3oDfbwP7knshje1ccZghf8Ws7p7f6UyO3p6Zh5eHw5lENQxfO0uSF2OPKjpaTeQRV3G+zVC+zXbceKb99RwB7YDjmguBgkxcZkaJbQUw9SBSFVIG1Xq57DHOXjETU6aNIYdpyWN1Vh8JuWUObSympEUGuQV2Eig0K2jpmuvYRavdA7l5PEitrWPREvo41iml2q/3LGzIDdR0tFGhOisseYHnTpRcAv8rA4gS4/BZ8VHOehEVTKKmuANbRginF0BPPB0J/lh98x7tTlNZAIrisdEDdFTriZhgmaKbvpmOAo6jSc5D5DMRpCfmpOIt0U/rj/YWvhS1FXDcw5Rr/hZJUEpnc
 EgoWl38U
 rwFqMinu+OBEvQNVeGQGAmTmqSpPXAVkglbKoaoYEB8wGA+vaGaNvChaIgKR1JClINJ8BnX3ojL/8zPfEywYY5m5a87PFjwDWk9MdPo/5fLwGdwdQZ/U3ce/BnR9I3iTJ1Gze7nTehShHJItoxS/B1NxcC3wsdeDMC2l3KIq3I9wz5XlXaP2R29MrgcXsNllYeCLnTetowJDr0xNc0R/OiZmuIIB7cVUZmRBA45lbiKopqExztLsUguK+Fon+1dMVEuGUA6Rcqnso0YQnXnked3wqg50tFuQD8hhlV1aM2LSlGr0WuBlnemxns6i69KYe9ShRt6Uou/2bb+9XZoPnP+V8K87X+Ky3o0OHYg6wZ+yvNVM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 2026-04-29 at 19:47 -0700, Matthew Brost wrote:
> On Fri, Apr 24, 2026 at 09:26:18AM +0200, David Hildenbrand (Arm)
> wrote:
> > On 4/24/26 09:05, Thomas Hellstr=C3=B6m wrote:
> > > On Thu, 2026-04-23 at 15:21 -0700, Matthew Brost wrote:
> > > > On Thu, Apr 23, 2026 at 12:08:36PM -0700, Matthew Brost wrote:
> > > > >=20
> > > > > If the order were included in shrink_control, there is about
> > > > > a 95%
> > > > > certain that this change would allow TTM / Xe to break the
> > > > > problematic
> > > > > kswapd feedback loop. This may also better express the intent
> > > > > of
> > > > > the
> > > > > problem we are trying to fix here.
> > > > >=20
> > > > > For reference, the cover letter [1] details the problem.
> > > > >=20
> > > > > Any guidance from the core MM folks would be
> > > > > appreciated=E2=80=94would
> > > > > adding
> > > > > the order to shrink_control be an acceptable solution?
> > > > >=20
> > > > > Matt
> > > > >=20
> > > > > [1] https://patchwork.freedesktop.org/series/165330/
> > > > >=20
> > > >=20
> > > > It doesn't look like __GFP_NORETRY, __GFP_RETRY_MAYFAIL,
> > > > __GFP_NOFAIL
> > > > make it to the sc->gfp_mask flags from the caller and get into
> > > > kswapd
> > > > loop...
> > >=20
> > > Perhaps that's because they mostly (only?) make sense from direct
> > > reclaim? Looks like the trace is from kswapd.
> >=20
> > kswap obtains the desired order through pgdat->kswapd_order, as a
> > hint from
> > allocation code (wakeup_kswapd). The order can be easily merged
> > (just use the max)
> >=20
>=20
> Yes.
>=20
> My current thinking is wire the order into shrink_control as that is
> quite straight forward + only call this helper + short circuit
> shrinker
> on higher orders.
>=20
> > We do have the gfp_flags there, but merging them from different
> > wakeups is a bit
> > more tricky (and when to reset?).
> >=20
> > Assume we have one urgent request for order-0 and one non-urgent
> > (noretry,nofail, ...) request for order-9, we'd have to figure out
> > a way how to
> > represent that. Gets more complicated for more orders.
> >=20
> > Of course, we could have some kind of array, and try to store some
> > "priority"
> > per order. But I assume plumbing that into the rest of kswapd might
> > not be that
> > easy.
>=20
> Yes, this seems non-trivial. I was also on a call with Google today
> discussing what Android (client Linux) would like from shrinking, and
> my
> initial feeling is that we will need to do some surgery to the
> shrinker
> core and GPU shrinkers to make all of this work well over the next
> year
> or so.
>=20
> So again, I think starting with wiring order into shrink_control and
> this helper is a good place to start, as it fixes an immediate issue.
>=20
> Let me know if that seems like a reasonable direction.

+1 for wiring order into shrink_control, and possibly also the priority
as mentioned in an earlier email.

However for cgroups-aware shrinkers, The number of free memory in a
zone might not be an indication of fragmentation-triggered reclaim at
all, it could be the result of the cgroup hitting its memory limits.

So I think if we can solve this with a combination of GFP flags,
plumbed-through order and plumbed-through priority, that would be
ideal.

Thanks,
Thomas

>=20
> Matt
>=20
> >=20
> >=20
> > --=20
> > Cheers,
> >=20
> > David

