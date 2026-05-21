Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA8AACD5BAB
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 22:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9D4B6B0096; Thu, 21 May 2026 18:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4E486B0098; Thu, 21 May 2026 18:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B64136B0099; Thu, 21 May 2026 18:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A41486B0096
	for <linux-mm@kvack.org>; Thu, 21 May 2026 18:20:33 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0C68E161622
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:20:33 +0000 (UTC)
X-FDA: 84792847146.14.F60F6CB
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 261D7C0002
	for <linux-mm@kvack.org>; Thu, 21 May 2026 22:20:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZDiCZ6j1;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779402031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tFL4uh44e2osjW96okVmaXqXdngbMfy8bfdPJ/HYlLw=;
	b=xqK2M9xVu4T2wEel7Qkx+k0HIw+x+oUNKGGhgpCvM4h+7+yawh0CvhJe7PIUmiUny5AWx/
	VJQpmbZRduWu6TEmPnvIKuHMV3PxZd01t0GADZQDauVPiWyqCq7ufq9izYUjeGiubQyFTw
	7sLQB8AqC3W0RtBX1XXJENBiGHIGXXU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=ZDiCZ6j1;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779402031; a=rsa-sha256;
	cv=none;
	b=KkUB9WIVoofFbzBW3YWRYAlT+zcNI/aq/b1MWV8tJdpe8TMwU+wbVVZmaL2e0SmpDLCFJX
	QZDIcXvdT8LLVkCtLG6dYQYTYSv8LRCnJQd63w8y11GFnL91Rz5TpLy7WtsLmPkJ4PzeJO
	L8Wl3puTKI3qZLZU/Wj/dGGu84LKCxA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1601D41A0F;
	Thu, 21 May 2026 22:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7611F000E9;
	Thu, 21 May 2026 22:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1779402029;
	bh=tFL4uh44e2osjW96okVmaXqXdngbMfy8bfdPJ/HYlLw=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=ZDiCZ6j1CFm38N3scsO8Zkw7tw4OdhWhXcSz8PPSTNuBEYjrYpcdrAnh35DRc3SJ8
	 tiyi6snhVvSydpoFs3zRqE8gG+qkCCoZuRK3DKra87F9zxqMJZsJkCd7Sib2NIshaD
	 xdHfK9Nj3gRo305i/noMvbpBiV+KSeSUMPN2dWTs=
Date: Thu, 21 May 2026 15:20:29 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Li Zhe" <lizhe.67@bytedance.com>
Cc: <apopple@nvidia.com>, <arnd@arndb.de>, <bp@alien8.de>,
 <dave.hansen@linux.intel.com>, <david@kernel.org>, <mingo@redhat.com>,
 <rppt@kernel.org>, <tglx@kernel.org>, <kees@kernel.org>,
 <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
 <linux-mm@kvack.org>, <x86@kernel.org>, <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH v2 0/7] mm: speed up ZONE_DEVICE memmap initialization
Message-Id: <20260521152029.4299697d40ddc58c721bbafd@linux-foundation.org>
In-Reply-To: <20260521040124.10608-1-lizhe.67@bytedance.com>
References: <20260521040124.10608-1-lizhe.67@bytedance.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 261D7C0002
X-Stat-Signature: 7s6jdse734pqhbe65esdhtpq6kzncczu
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779402031-3495
X-HE-Meta: U2FsdGVkX18oiEp9M/GmwwvoHP61YfYKfP0icq2/9eQMOBPAoX3o2FvXVwRAMadAPYbiDKQhG4KSS7ze56SYuM19xnzxg/5XKsnm/sIKdg7F52D/oiloPqpRLFAn8mk6sq3UoAlRUQ35QU1h9pwne85HeACXypBhlpa0iheKS31+BGVKjxaosmfT+NsCKDRUCztz3oBO0VHimnpDNpnGCsmtz6q+mqlrSL3HYr6fp5rodQ6JrdjY73l/Yg1KpxQFwXV5QNR6gP5mkAuu675wpHAe/s4bKTXtrnC1FpOdFKMWwU4oDHJnqqzSRvqLgNhAMCz0u/09x9ogkp+6Ri1b9QdnRUVf69bFwK3uUoqRClm4imrj0wUfJhR9E2LbJS6ebCPQP6iZU94nPREJ/5VWv418FitRcU+K5UFIb46vGAh/n6d6FDqgSF5EL5O8TA0uP8Z0ArnAN8lHYeVqL9meNUfEct2aY9k/nImn8ZlgEkKlIY2kRLWwAFSiPSnsF7O4ID6EfIcsIZPaMG7B2A7IVs+GePnt7HyVL47YH0Xcp8/xf4ZIeHKtia8VMHfDFaCjHRl8h59zi70biQKDkbhkvxmQ2Mh/OIFMfXLtCn4mQVcBQBVUZNdO2svWCoMzDtI+1dVC/8RCSwvpz2c7LhGs4Wvge0/KLsdfnFxfXUe4KxeTWoJUY/GfHIcRXCLvYlLOh75HQXt8ZFIPTmQbHqyZv7/RPPcESNDH55DQB6eYbo+p3zdgAJldL0EtrZSrfFHjRatb6mQber/MZd1Us3qv1KE2/kokEyU8JISaqUL4w9T81UElMeRRkAuVY1Fq1gkPuvrTSQypPGkoZDiJZ07zaJVUfd4mHDcatfgWcvwCmR/9jKGofrNS/YZAFllrTVP6kbaA3DYJFD8QjetIWQ4QHoKF4PUU33AZLN6Lcj2COKgRRI96a+TQwhnVKXJFXT6CuAiGPwDp9Qk9CZOc8Zn
 f5ywXIX1
 lhqCd2/7Cz2jCU/Mx6+SgGW4Qu8omZXtTPAOyjzAKydl0G9HCq8w6yMANlVXwy+6pvXaT8N9cn1Op5mcMnbs/4RXG4367I3LuocyrOMZ8R+aUBC3RUVdj0dm+iGxfszxOWCjac97riPZEIuX//wrGODKWsA94xuv3P/hkTphOE/xtG8a6hVemhZc6fWpSPAXlZ6jO/dezihkvJ5J6yi6cuHkufxciAGChkwGM03zdMkXv31JlGevAb5hggLKq/6JJoKoOiAfgm0Kit63X1D/XjpP4usBTT2PBc/qzDfR2ZVR+KQiNGqcIFhGRKe64kv3pqbpg7qQGxpvzfvVcEMXfLxzTWTShbFuqhH2oDy++SbXeGHTxej4CNeNMuKbMsHw97qAM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 May 2026 12:01:17 +0800 "Li Zhe" <lizhe.67@bytedance.com> wrote:

> memmap_init_zone_device() can spend a substantial amount of time
> initializing large ZONE_DEVICE ranges because it repeats nearly
> identical struct page setup for every PFN.
> 
> This series reduces that overhead in seven steps.

Cool, thanks, we all love speedups.

> The first patch factors the reusable pieces out of
> __init_zone_device_page() so later patches can share the same logic
> without changing the existing slow path.
> 
> The second patch adds set_page_section_from_pfn(), so generic callers
> can update section bits from a PFN without open-coding
> SECTION_IN_PAGE_FLAGS checks.
> 
> The third patch adds a template-based fast path for ZONE_DEVICE head
> pages. Instead of rebuilding the same struct page state for every PFN,
> it prepares a reusable page template once and copies it to each
> destination page.
> 
> The fourth patch extends the same template-based approach to compound
> tails, so pfns_per_compound > 1 can also benefit from the fast path.
> 
> The fifth patch introduces memcpy_streaming() and
> memcpy_streaming_drain() as a generic interface for write-once
> streaming copies, with a memcpy() fallback for architectures that do
> not provide a specialized backend.
> 
> The sixth patch extends x86 memcpy_flushcache() small fixed-size
> fastpaths so struct-page-sized streaming copies can stay on the inline
> path.
> 
> The last patch switches the zone-device template-copy path over to
> memcpy_streaming(). It refreshes PFN-dependent fields in the reusable
> template before each copy, keeps pageblock-aligned PFNs on regular
> memcpy(), and drains streaming stores before later normal stores update
> overlapping or dependent metadata.
> 
> The optimized path is disabled when the page_ref_set tracepoint is
> enabled, sanitized builds remain on the slow path so their
> instrumented stores are preserved, and the fast path falls back to the
> existing slow path if sizeof(struct page) is not an integral number of
> u64 words.
> 
> Testing
> =======
> 
> Tests were run in a VM on an Intel Ice Lake server.
> 
> Two PMEM configurations were used:
>   - a 100 GB fsdax namespace configured with map=dev, which exercises
>     the nd_pmem rebind path (pfns_per_compound == 1)
>   - a 100 GB devdax namespace configured with align=2097152, which
>     exercises the dax_pmem rebind path (pfns_per_compound > 1)
> 
> For each configuration, the corresponding driver was unbound and
> rebound 30 times. Memmap initialization latency was collected from the
> pr_debug() output of memmap_init_zone_device().
> 
> The first bind is reported separately, and the average of subsequent
> rebinds is used as the steady-state result.

How closely does this workload resemble any real-world user workload?

> Performance
> ===========
> 
> nd_pmem rebind, 100 GB fsdax namespace, map=dev
>   Base(v7.1-rc3):
>     First binding: 1486 ms
>     Average of subsequent rebinds: 273.52 ms
>   With patches 1-3 applied:
>     First binding: 1422 ms
>     Average of subsequent rebinds: 245.73 ms
>   Full series:
>     First binding: 1389 ms
>     Average of subsequent rebinds: 111.08 ms
> 
> dax_pmem rebind, 100 GB devdax namespace, align=2097152
>   Base(v7.1-rc3):
>     First binding: 1515 ms
>     Average of subsequent rebinds: 313.45 ms
>   With patches 1-4 applied:
>     First binding: 1422 ms
>     Average of subsequent rebinds: 256.56 ms
>   Full series:
>     First binding: 1294 ms
>     Average of subsequent rebinds: 110.24 ms

The improvements appear to range between "modest" and "large", but what
I'd like to understand is how frequently real-world users are using
these operations in real-world workloads.

IOW, (and this is always the bottom line), how valuable is this
patchset to our users?

>   mm: factor zone-device page init helpers out of
>     __init_zone_device_page
>   mm: add a set_page_section_from_pfn() helper
>   mm: add a template-based fast path for zone-device page init
>   mm: extend the template fast path to zone-device compound tails
>   string: introduce memcpy_streaming() helpers
>   x86/string: extend memcpy_flushcache() fixed-size fastpaths
>   mm: use memcpy_streaming() in zone-device template copies
> 
>  arch/x86/include/asm/string_64.h | 100 +++++++++++++---
>  include/linux/mm.h               |  19 ++-
>  include/linux/string.h           |  18 +++
>  mm/mm_init.c                     | 198 +++++++++++++++++++++++++++----
>  4 files changed, 294 insertions(+), 41 deletions(-)

I won't take any action at this stage - let's await reviewer input.  If
none is forthcoming then please remind me and I'll figure out what to
do.

The ever-present reviewer called "Sashiko" has thoughts to offer:

	https://sashiko.dev/#/patchset/20260521040124.10608-1-lizhe.67@bytedance.com

Please take a look, decide if there's useful material in there.


