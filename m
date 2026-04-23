Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECE69F99377
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 11:27:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29E6F6B0005; Thu, 23 Apr 2026 07:27:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24F796B008A; Thu, 23 Apr 2026 07:27:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13F256B008C; Thu, 23 Apr 2026 07:27:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F3B0B6B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 07:27:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 948D11A05C9
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:27:21 +0000 (UTC)
X-FDA: 84689594682.16.F9A7FE0
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.13])
	by imf29.hostedemail.com (Postfix) with ESMTP id E5B11120007
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 11:27:18 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BzHmXZgW;
	spf=pass (imf29.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776943639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ly1fQD5g76ToEYP4CAg+Tw5zwFRXLqaRn1f/HESFoGI=;
	b=uzrY0iNw6/YPm7R4ya1ZkCj/fwI0ODWJIVskGYyMpqbLfsmLNiHWgHkLbrWYuki5qgCtEe
	7P6XOnjTh8jFW71BRpnwVB7dLvHEy90Y0rPblPBeJsOO2nxa/+WzfVbDSWGIkbBgHV4aIT
	hS6DWtn1v5UxVPvojhoip9fYJn1S6Ic=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=BzHmXZgW;
	spf=pass (imf29.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.13 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776943639; a=rsa-sha256;
	cv=none;
	b=furDhrVWerEqmFNNgo6L0u3xGTIdMdENX8M4WNFYR4g5bW01jvY/4LGwFkVHf8T0rYPl66
	/pS01t0l6Mee6sxtov3EfyKTrcqVZiyfoqcTIeyV7ObsAy9c8xzMXAc7VXu3ElnXBIPFK+
	m2igAemPdXFisCN6vbNeD/FxjyQEqRU=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1776943639; x=1808479639;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=5YI735XPEJkCgWEsucBd5PrMiYz/IupiNSJb7R/0oJ4=;
  b=BzHmXZgW5ykhMxz7U5X3/Ufm5QQmnPgbVM3VRVNVafdqK9m+qlIBW5dU
   /thJqZW5KQiclddGxfgrVe+H+GRFRH0apXCEbvdhITYyaWC4rpZLu8mLT
   Ggvl44tIn9dKuApu6D842zz3oXrRwbgq6a9cICBW1ubOzcqKwtXj6S0/7
   GHlm4ByCqzxrB57inhrIBj6kdZ0OiSM16fVKm6kFc5+bQF3krx4Ig54Jq
   yktiS0XNlep/oBTti4a+tOAYCAMSKmekk7spgiYsM3Sc6AGJerPSeMNwL
   kA4zLtkyQ9Fz3/Q++9m/a2SJv7Rrtfxxs25CCdhnD2wkPTfCTlIfgI2Wi
   g==;
X-CSE-ConnectionGUID: HtyVouTiSbqdmg+e3h2Dnw==
X-CSE-MsgGUID: leReaVo4Rg2dAjFEF5G4bg==
X-IronPort-AV: E=McAfee;i="6800,10657,11764"; a="80495787"
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="80495787"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by fmvoesa107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 04:27:17 -0700
X-CSE-ConnectionGUID: ZEX+4CaZQgClv5j6ht9r2g==
X-CSE-MsgGUID: 9rckGPeQRxCBLBGfWmbzJQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.23,194,1770624000"; 
   d="scan'208";a="232538257"
Received: from zzombora-mobl1 (HELO [10.245.244.147]) ([10.245.244.147])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Apr 2026 04:27:14 -0700
Message-ID: <be42059924cde9bb16a087ee2a5abb0b9d850d68.camel@linux.intel.com>
Subject: Re: [PATCH v2 1/5] mm: Introduce zone_appears_fragmented()
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, Matthew Brost
	 <matthew.brost@intel.com>, intel-xe@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org
Cc: Andrew Morton <akpm@linux-foundation.org>, Lorenzo Stoakes
 <ljs@kernel.org>,  "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,  Suren
 Baghdasaryan	 <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, 	linux-kernel@vger.kernel.org, Johannes Weiner
 <hannes@cmpxchg.org>
Date: Thu, 23 Apr 2026 13:27:11 +0200
In-Reply-To: <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
References: <20260423055656.1696379-1-matthew.brost@intel.com>
	 <20260423055656.1696379-2-matthew.brost@intel.com>
	 <76191a17-18bf-4e9b-9ab5-dc9a48abfabb@kernel.org>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.3 (3.58.3-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: tf9z8wpya1p1b3edtc4ftwpyjmrquzfr
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5B11120007
X-HE-Tag: 1776943638-912199
X-HE-Meta: U2FsdGVkX18w2JdSQQYbOzk1m74pehl7l3S1lYeev0BF3leXBb//cU7dQyFBC2zS9X0mbOZuLNLIK6et/st/Rm1t5re+3AIzt6zNwPnxiu8CHWSHwL0EPWBujRo7DHH2gcDVjct2PsmWoLfO07z4hWVFuGtfRyzX4fzkSlZG8Nh3jI2xMxQbhsVppVQaw7iK0EMQYSMrlOnWHUVg32XgTBYiF6WgDMGPuBgU0Em5mTc9Vg6Zi/lf7wHVWEyY4aLhd5huVHNga0D7KE1kFtvm47u1FQrFd/z2N9JVmfgIdnRFvtxpa+sUa5EmVUElUBKVIq9Z6/IsxF/E3aNw5S+tPsRS0EjHsMqv5MGmpzfYeegnjiFUfwcp/eEwrb5XMg7C02677ZqGoJRWceH+56K0A4OXck1TbsSDqxRWqLgv2ctRviesPfnwuwd+0BZ+5iRV9f+c7ORWcW+b2mtR8mvDa2ud7EYL3fnZYy/n74az+pUtiPvgxkpzgf/bBEEt4LeWmJzQPziR/4+XPp6awRDy2A37NOzQmIExOxtDTXtwafDytQYQx0hpzkPTqpHRODpQjeqfxLFc79rxJTrATWaNZaIimttM2qqor7zCEiKFeQO+CHVE1nKIHPdT31TTjE3q/VO7U8IB80g0b+r93Qvcm+TkN3++lPwj6TFP1n8KzbZKiym0MuDvlqocZO/MQ8fdrv4UIkOMO8QUDfrjK80BAOtemDq/AfwwxHRZBYqYZPlLz0AeNuqZRJ0RntBVGsfpNDVuO0Q5mtvDldoZeV50LFbWIAGCPaf1RbRDS78q3Ct9X9V7OMk0QAUEya5xKrmtUkLjQE/Gyd0RpePrmcbVuo93//UvA79zapxMRPlpKgojOlT20FR4aZrVqlGDB3iCjSueuy1xC9tHJjVBkoKfkxaGbrnxh3XagOQGb96Qgd+5hhZOkMfgnG+mns1sT35UNMaXQKGsj8ZZ8+nNgrR
 cTXG4KOR
 piWDnzWGohVcUltnA/3nhOweqKemtMpIEP5iFFZmivav7qZu5ziRiCJWQwofyruYBLTtA/cQwotBIuAfZBBF5F/lZ8H2M/cqngLuIUC1cOpBBmlDZZmflU7lL8yK8v1+tWrtbpWDKKaHG8DvIFxRXh8OyV+4kq6OjS1uBhCtQpvXGgQUFUuhQumxnjY2nOX9ho9KLmuIrXl0ki20M3VW7t2OUyPo+CA7o5uqVzdT4GkaZCcU/LYkNRy3wTTXJbFWYICirqTDZsIyhITROl6eub040/W0IUUpyZroEjvOIrsKQ+lGH7czLdb6yn1B98FcaQS+XdQmTki0bm8nayjMiRZkuxz+WnMzrP9z3bkBh6of8ZAbQI4rZCK2W0nxQ+NQojm0T8vdIE0Z7Fk6/PpQUqjzGw5lmMZ/KSunLxQ/AZqAVe6VVMh5wblVrSvKsflR974OVdUcwSCDoHDqMaR6288dd1FvcTRMxLS+nwySrmPfgKc1RaHS9GVvh1zxhk/xWcNalvdT5OQSt2fg8qW7HOteVqRZvm0VENgpZKc8Adi4wD7u1ZANoDR82uxjHdduwU7wB
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-04-23 at 12:27 +0200, David Hildenbrand (Arm) wrote:
> On 4/23/26 07:56, Matthew Brost wrote:
> > Introduce zone_appears_fragmented() as a lightweight helper to
> > allow
> > subsystems to make coarse decisions about reclaim behavior in the
> > presence of likely fragmentation.
> >=20
> > The helper implements a simple heuristic: if the number of free
> > pages
> > in a zone exceeds twice the high watermark, the zone is considered
> > to
> > have ample free memory and allocation failures are more likely due
> > to
> > fragmentation than overall memory pressure.
> >=20
> > This is intentionally imprecise and is not meant to replace the
> > core
> > MM compaction or fragmentation accounting logic. Instead, it
> > provides
> > a cheap signal for callers (e.g., shrinkers) that wish to avoid
> > overly aggressive reclaim when sufficient free memory exists but
> > high-order allocations may still fail.
> >=20
> > No functional changes; this is a preparatory helper for future
> > users.
> >=20
> > Cc: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> > Cc: Andrew Morton <akpm@linux-foundation.org>
> > Cc: David Hildenbrand <david@kernel.org>
> > Cc: Lorenzo Stoakes <ljs@kernel.org>
> > Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>
> > Cc: Vlastimil Babka <vbabka@kernel.org>
> > Cc: Mike Rapoport <rppt@kernel.org>
> > Cc: Suren Baghdasaryan <surenb@google.com>
> > Cc: Michal Hocko <mhocko@suse.com>
> > Cc: linux-mm@kvack.org
> > Cc: linux-kernel@vger.kernel.org
> > Signed-off-by: Matthew Brost <matthew.brost@intel.com>
> > ---
> > =C2=A0include/linux/vmstat.h | 13 +++++++++++++
> > =C2=A01 file changed, 13 insertions(+)
> >=20
> > diff --git a/include/linux/vmstat.h b/include/linux/vmstat.h
> > index 3c9c266cf782..568d9f4f1a1f 100644
> > --- a/include/linux/vmstat.h
> > +++ b/include/linux/vmstat.h
> > @@ -483,6 +483,19 @@ static inline const char *zone_stat_name(enum
> > zone_stat_item item)
> > =C2=A0	return vmstat_text[item];
> > =C2=A0}
> > =C2=A0
> > +static inline bool zone_appears_fragmented(struct zone *zone)
> > +{
>=20
> "zone_likely_fragmented" or "zone_maybe_fragmented" might be clearer,
> depending
> on the actual semantics.
>=20
> > +	/*
> > +	 * Simple heuristic: if the number of free pages is more
> > than twice the
> > +	 * high watermark, this strongly suggests that the zone is
> > heavily
> > +	 * fragmented when called from a shrinker.
> > +	 */
>=20
> I'll cc some more people. But the "when called from a shrinker" bit
> is
> concerning. Are there additional semantics that should be expressed
> in the
> function name, for example?
>=20
> Something that implies that this function only gives you a reasonable
> answer in
> a certain context.

I think that test would not be relevant for cgroup-aware shrinking.

What about trying to pass something in the struct shrink_control? Like
if we pass the struct scan_control's order field also in struct
shrink_control, really expensive shrinkers could duck reclaim attempts
from higher-order allocations that may fail anyway:

      if (sc->order > PAGE_ALLOC_COSTLY_ORDER &&
           (sc->gfp_mask & (__GFP_NORETRY | __GFP_RETRY_MAYFAIL)) &&
           !(sc->gfp_mask & __GFP_NOFAIL))
           return SHRINK_STOP;

Possibly exposed as an inline helper in the shrinker interface?

/Thomas





