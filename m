Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7141FFB44C2
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 07:05:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D320C6B0005; Fri, 24 Apr 2026 03:05:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2036B0098; Fri, 24 Apr 2026 03:05:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0C56B0099; Fri, 24 Apr 2026 03:05:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5CAF6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 03:05:27 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 52D921C0AF6
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:05:27 +0000 (UTC)
X-FDA: 84692563494.29.5FCB9EB
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.12])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5CFD1180003
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 07:05:24 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G1aAAIGz;
	spf=pass (imf06.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777014325;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lv8en6ROVToGVO6NQlpsZwsbrBP5PFlYZ+7SkBfTmCs=;
	b=o2f//aA+y6tocBVi/uIEKlCnZ0Tw35P3Jcmk9s7SvS1Q7BkgZPKazqK+t9GGyV/NbEX99z
	7GGtZjzIPtIvImfXiBT7bpUBs4uhJ9kTXF/1paPQvziEmHPnuLWE4G/kFmiaRx04saGaa0
	6zNOMyL5tXFtL7HYzW0oXT0wAaDEaFc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777014325; a=rsa-sha256;
	cv=none;
	b=hNE1jSZRthtxsqTxZfuizVMbsrkeu4FIjYqKulKZaYopm/yijAqVUI/qEntS5Mwc4C0nzV
	RHhy1GPlNX6T07ixC5JHyPO5SVkiBumiNfOi33K7jO26AxuwgUqZpmE1Uz2VXEAMj0TsYj
	818r4kwcdANbid3Z0POf8CTFFf2aS88=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=G1aAAIGz;
	spf=pass (imf06.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.12 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1777014324; x=1808550324;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=wKkQjksF58KOBShBOIr4QCuWLnUJX6G0srOO77XVonw=;
  b=G1aAAIGzL9m0QZtHGKsGnt2yMJnrC2ug+nSfoulAHRja7K55j4Edkzt2
   28iDv/wFu1HfLzHeOy2sHn33AXC8ld8mMAWI9E00p4WktLJNKpwWeVp1z
   pNw6+sG4Dkuf/4APZcBs1cgd3r5VgQOqp22o5NhMLFoFbcU3ut73Pzkf4
   jQV9jTi4zKf6H1AfLlVvvrAznzSQMXZ4GOkqQagamCxF6THtA1uFQUvV5
   hYz18VF7eUuobMmpzWOlC039Exga0ZAC0iGS2nC1wN4N464F1SRYAnMQB
   tDfAmiH8jeZiPlRGKQAg4vh8GZBHhKjMQpDM4CDAPyEGkIHlFJd0T9XKR
   Q==;
X-CSE-ConnectionGUID: DSa8mfpmSCO96r40u0Neiw==
X-CSE-MsgGUID: nG0nmA/5STeKkHdvxK70Hw==
X-IronPort-AV: E=McAfee;i="6800,10657,11765"; a="81852600"
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="81852600"
Received: from fmviesa006.fm.intel.com ([10.60.135.146])
  by fmvoesa106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 00:05:22 -0700
X-CSE-ConnectionGUID: jALR2HnjQy2FSh+IwLvczw==
X-CSE-MsgGUID: AFI2FRyNTSWr9Z8LdXAzDA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,196,1770624000"; 
   d="scan'208";a="228315564"
Received: from pgcooper-mobl3.ger.corp.intel.com (HELO [10.245.245.58]) ([10.245.245.58])
  by fmviesa006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2026 00:05:19 -0700
Message-ID: <291406b26b8badf2e565996515931d9ebe50208f.camel@linux.intel.com>
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
Date: Fri, 24 Apr 2026 09:05:16 +0200
In-Reply-To: <aeqbe/9YRKNyYuWY@gsse-cloud1.jf.intel.com>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
	 <20260423055656.1696379-2-matthew.brost@intel.com>
	 <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
	 <be42059924cde9bb16a087ee2a5abb0b9d850d68.camel@linux.intel.com>
	 <aepuNL2fwp47P1Wi@gsse-cloud1.jf.intel.com>
	 <aeqbe/9YRKNyYuWY@gsse-cloud1.jf.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: zy844mjhodjymztgw3ncom4npoth8fbk
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5CFD1180003
X-Rspam-User: 
X-HE-Tag: 1777014324-744467
X-HE-Meta: U2FsdGVkX1/ho047BE6inZfR8J39iDV8ExAuQg8/h5JJEvk/e0RU6veBXLe9yn5ZoCY7LjANQV8xhmwHXucZvDo/pkPMpJHH74uMf5XK9OnGhG5/1Y3qzLgvlNVSV8tBEtEf/JPoVo+osFK0lzVhJEGF7fuhwujka4WTPJ8DyebArNAzVCJPVu0dq5WavwQ0XAqpfoFaFdi+PUyGa96L5jDz25uWOBzfP7n/w7HSs6EEoV9DF1C12f1+oCQd1+8v0zAMkb2TD3JjX+wra1zmd0lo+CecaQUGMlBBCZevu/CQpNon4+SmFv1lC4WPVgPAyW305lsnuRvINTAQUvwE9ZXigqIP1NkW3I3uW0/xAlnQCCKfe4Vlime1HYVbLtxPKleIhNe5h7s9HU6fEzltTz7x8NILVVntM6s/cwc3/ecvdA+sRPBPWMCouSz1maRKzKOUyC7EvrgsFKfn2S4NdSlBojyhAQj0tuH30TL32gk8dNY9YHqNZEezdJRnqknTXZLg/nV65YH2oqRrgZ40RiiRU0OBmpVnLuUsDFL9HpvTAYEkgU0XVwHHHKTXX0VjlCLrHgxHbaG+7ishF/eyNgLYsjJ1LxC5A9QYkjMZf/7UJZNADBCUhKZ7tUE9JhAFdHn6pVtKSNJSd9rEo8vo9L6nYxSWRTue5ln2jDlUsYXY8YjgPky6ZFCJoN+MEQwZ2mm82vB9F8gX00vpyvouP/kbutm98ogBHJoWQwm/VCjfaDMAJZOefWEWEc1ZNLSg6A4Z/hP0SQ/l8+JeIm7+k2Aw/C5s0g9uE6Fzln2mM+w1OvcMTrchpO2ufZ/rd8MEC62Z1OWGOyYqDm0dUhgb/Q1kNwzD1Hx9/zksxNRKjNm7hx2czrWKuHWENhG8nmyyzmq766iggdrGPO41EQ8lcscTYOZETuhlxuyXpd1LR8Akm0cDajk0iPpbIEXber1TDt5hzLjo49eQ9C92yFT
 Izie0COr
 yqO5mhtSqU18KgJe/tjrBTkXqifCDAzubgANn5TkQzh3LBnE3Xt8L7y+8sNkvJ0uAc0wWUA2djXLk3QXqLj0DDaidzs/RdHQ6J7KhWh4RFBMddtJo3/wYrZtDkNYJWZ64WB98LS2rDP+mtEVkvzuFErsSflhT4U+2E3MzUBGBZxHonH/HkRlCheWC14ICkZuMaaJEJMKsWJX6YzmTqmoDRbcjjdtDeELJ792sSvQMxklwpV7mc/Ze324LWxtUJC/FlzqRLjNc7Xguv95sDYWUuz1h8yzV6OdOcsumVAmXAeAtVXLw6OzL7WBCFCNYyNDlPyezOy8pNwuRHe+QrlCeCRMDYgyl4fDUu5/CnpuK4cjgDPsaNY59O3WJIau8nzIwxMLLxcwaJsTMSAfQIyRPDfyInUxOQH3nLS85qV6UT/Y81zjPh/RkU/NLHUNqT8DkHELWV7D+csmMYy6MjiV/W23xm5/yiYaNymPIuGVWqBUxyqq9l0eZdW+ItKVC9k57eX3lfNdarDBD4MsLPEM3iWYWTElgxiGDzwIAHsI5XUXGFoW+s4yYz7LVuxoBfzHJfYe0Toz0QGvdvCfzvghtxs1vX19cRiUtw682EeQZSfaqC5okPLX8dKeFPA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-04-23 at 15:21 -0700, Matthew Brost wrote:
> On Thu, Apr 23, 2026 at 12:08:36PM -0700, Matthew Brost wrote:
> > On Thu, Apr 23, 2026 at 01:27:11PM +0200, Thomas Hellstr=C3=B6m wrote:
> > > On Thu, 2026-04-23 at 12:27 +0200, David Hildenbrand (Arm) wrote:
> > > > On 4/23/26 07:56, Matthew Brost wrote:
> > > > > Introduce zone_appears_fragmented() as a lightweight helper
> > > > > to
> > > > > allow
> > > > > subsystems to make coarse decisions about reclaim behavior in
> > > > > the
> > > > > presence of likely fragmentation.
> > > > >=20
> > > > > The helper implements a simple heuristic: if the number of
> > > > > free
> > > > > pages
> > > > > in a zone exceeds twice the high watermark, the zone is
> > > > > considered
> > > > > to
> > > > > have ample free memory and allocation failures are more
> > > > > likely due
> > > > > to
> > > > > fragmentation than overall memory pressure.
> > > > >=20
> > > > > This is intentionally imprecise and is not meant to replace
> > > > > the
> > > > > core
> > > > > MM compaction or fragmentation accounting logic. Instead, it
> > > > > provides
> > > > > a cheap signal for callers (e.g., shrinkers) that wish to
> > > > > avoid
> > > > > overly aggressive reclaim when sufficient free memory exists
> > > > > but
> > > > > high-order allocations may still fail.
> > > > >=20
> > > > > No functional changes; this is a preparatory helper for
> > > > > future
> > > > > users.
> > > > >=20
> > > > > Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > > > > Cc: Andrew Morton <akpm@linux-foundation.org>
> > > > > Cc: David Hildenbrand <david@kernel.org>
> > > > > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > > > > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > > > > Cc: Vlastimil Babka <vbabka@kernel.org>
> > > > > Cc: Mike Rapoport <rppt@kernel.org>
> > > > > Cc: Suren Baghdasaryan <surenb@google.com>
> > > > > Cc: Michal Hocko <mhocko@suse.com>
> > > > > Cc: linux-mm@kvack.org
> > > > > Cc: linux-kernel@vger.kernel.org
> > > > > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > > > > ---
> > > > > =C2=A0include/linux/vmstat.h | 13 +++++++++++++
> > > > > =C2=A01 file changed, 13 insertions(+)
> > > > >=20
> > > > > diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> > > > > index 3c9c266cf782..568d9f4f1a1f 100644
> > > > > --- a/include/linux/vmstat.h
> > > > > +++ b/include/linux/vmstat.h
> > > > > @@ -483,6 +483,19 @@ static inline const char
> > > > > *zone_stat_name(enum
> > > > > zone_stat_item item)
> > > > > =C2=A0	return vmstat_text[item];
> > > > > =C2=A0}
> > > > > =C2=A0
> > > > > +static inline bool zone_appears_fragmented(struct zone
> > > > > *zone)
> > > > > +{
> > > >=20
> > > > "zone_likely_fragmented" or "zone_maybe_fragmented" might be
> > > > clearer,
> > > > depending
> > > > on the actual semantics.
> > > >=20
> > > > > +	/*
> > > > > +	 * Simple heuristic: if the number of free pages is
> > > > > more
> > > > > than twice the
> > > > > +	 * high watermark, this strongly suggests that the
> > > > > zone is
> > > > > heavily
> > > > > +	 * fragmented when called from a shrinker.
> > > > > +	 */
> > > >=20
> > > > I'll cc some more people. But the "when called from a shrinker"
> > > > bit
> > > > is
> > > > concerning. Are there additional semantics that should be
> > > > expressed
> > > > in the
> > > > function name, for example?
> > > >=20
> > > > Something that implies that this function only gives you a
> > > > reasonable
> > > > answer in
> > > > a certain context.
> > >=20
> > > I think that test would not be relevant for cgroup-aware
> > > shrinking.
> > >=20
> > > What about trying to pass something in the struct shrink_control?
> > > Like
> > > if we pass the struct scan_control's order field also in struct
> >=20
> > If the order were included in shrink_control, there is about a 95%
> > certain that this change would allow TTM / Xe to break the
> > problematic
> > kswapd feedback loop. This may also better express the intent of
> > the
> > problem we are trying to fix here.
> >=20
> > For reference, the cover letter [1] details the problem.
> >=20
> > Any guidance from the core MM folks would be appreciated=E2=80=94would
> > adding
> > the order to shrink_control be an acceptable solution?
> >=20
> > Matt
> >=20
> > [1] https://patchwork.freedesktop.org/series/165330/
> >=20
> > > shrink_control, really expensive shrinkers could duck reclaim
> > > attempts
> > > from higher-order allocations that may fail anyway:
> > >=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (sc->order > PAGE_ALLOC_COSTLY_ORDE=
R &&
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 (sc->gfp=
_mask & (__GFP_NORETRY | __GFP_RETRY_MAYFAIL))
> > > &&
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 !(sc->gf=
p_mask & __GFP_NOFAIL))
>=20
> It doesn't look like __GFP_NORETRY, __GFP_RETRY_MAYFAIL, __GFP_NOFAIL
> make it to the sc->gfp_mask flags from the caller and get into kswapd
> loop...

Perhaps that's because they mostly (only?) make sense from direct
reclaim? Looks like the trace is from kswapd.

Another metric to weigh in is perhaps the scan_control::priority field.
From my understanding it is progressively decreased towards 0 with 0
indicating most urgent shrinking.=20

Thanks,
Thomas

>=20
> =C2=A01182 [=C2=A0 394.049058] xe_shrinker_scan: no skip order=3D9,
> gfp=3D0x0000000000000cc0
> =C2=A01183 [=C2=A0 394.049061] CPU: 2 UID: 0 PID: 110 Comm: kswapd0 Not t=
ainted
> 7.0.0-xe+ #355 PREEMPT(full)
> =C2=A01184 [=C2=A0 394.049062] Hardware name: Intel Corporation Panther L=
ake
> Client Platform/PTL-UH LP5 T3 RVP1, BIOS
> PTLPFWI1.R00.3332.D05.2509011438 09/01/2025
> =C2=A01185 [=C2=A0 394.049063] Call Trace:
> =C2=A01186 [=C2=A0 394.049065]=C2=A0 <TASK>
> =C2=A01187 [=C2=A0 394.049066]=C2=A0 dump_stack_lvl+0x55/0x70
> =C2=A01188 [=C2=A0 394.049073]=C2=A0 xe_shrinker_scan+0x274/0x280 [xe]
> =C2=A01189 [=C2=A0 394.049181]=C2=A0 do_shrink_slab+0x132/0x360
> =C2=A01190 [=C2=A0 394.049184]=C2=A0 shrink_slab+0xf0/0x3e0
> =C2=A01191 [=C2=A0 394.049186]=C2=A0 shrink_node+0x2bd/0x800
> =C2=A01192 [=C2=A0 394.049188]=C2=A0 balance_pgdat+0x323/0x760
> =C2=A01193 [=C2=A0 394.049189]=C2=A0 kswapd+0x1c3/0x340
> =C2=A01194 [=C2=A0 394.049190]=C2=A0 ? __pfx_autoremove_wake_function+0x1=
0/0x10
> =C2=A01195 [=C2=A0 394.049193]=C2=A0 ? __pfx_kswapd+0x10/0x10
> =C2=A01196 [=C2=A0 394.049194]=C2=A0 kthread+0xdf/0x120
> =C2=A01197 [=C2=A0 394.049196]=C2=A0 ? __pfx_kthread+0x10/0x10
> =C2=A01198 [=C2=A0 394.049197]=C2=A0 ret_from_fork+0x1d0/0x220
> =C2=A01199 [=C2=A0 394.049200]=C2=A0 ? __pfx_kthread+0x10/0x10
> =C2=A01200 [=C2=A0 394.049200]=C2=A0 ret_from_fork_asm+0x1a/0x30
> =C2=A01201 [=C2=A0 394.049202]=C2=A0 </TASK>
>=20
> Will look into if this is fixable, but again any core MM guidance
> would
> helpful.
>=20
> Matt
>=20
> > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 return S=
HRINK_STOP;
> > >=20
> > > Possibly exposed as an inline helper in the shrinker interface?
> > >=20
> > > /Thomas
> > >=20
> > >=20
> > >=20
> > >=20

