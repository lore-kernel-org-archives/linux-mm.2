Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 604DFC44500
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 319BD6B00B7; Fri,  3 Jul 2026 05:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F1606B00B8; Fri,  3 Jul 2026 05:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B9DC6B00B9; Fri,  3 Jul 2026 05:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D73F36B00B7
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:20:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 55F52A04BD
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:20:18 +0000 (UTC)
X-FDA: 84946919316.19.088F3E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 781A2100007
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:20:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJVkb6Pg;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783070416;
	b=AyAd8hiczD/48ThKlELaBZsur94d5H3ga68kxrA3HYsLN1A0gQsJVDu/7CbjEXxwGWXSxb
	VnrbCVtkGBecfpWqrpYL151nkRE75VnoiSi7BCBi7Oovw4pMwmGpaOcF4IjyLLj2sZJhri
	FspaMU9uKCCJM8t2EMuKZCDE95AZ8DE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783070416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d4E5IgOb18AM4fykE8ujTxtcflOecYT/ixKCIOO2gbE=;
	b=EfYJDhHtDxBSk3FdrkWRAg+QlBloBGDzMMPSlTZMm/Wu9c3Zq4OLk6/Yew8ylacAb7WF+q
	HaKEjdhQy2YbNZeziBGjxVBjbLSUXBm/9x1PGOa4s5XQx98yoXV9xtFG33SE4WP2p0uG8S
	exTsZA8Qt0DZSGPEfHVkCnuARD7gM5w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CJVkb6Pg;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 779D942B11;
	Fri,  3 Jul 2026 09:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C053F1F00A3A;
	Fri,  3 Jul 2026 09:20:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783070415;
	bh=d4E5IgOb18AM4fykE8ujTxtcflOecYT/ixKCIOO2gbE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CJVkb6Pg3U6/GUJKKU0R11dPgY0dDvWoxBBtNay3u9a0oFX8rJYKLmNrt4rxPsjW6
	 xBqU0z7Ywh2AEz1hk/UnRQj6tNru1gpEM7P3yzhWoqTLMI4zSPvAAc1BlGGBo7QujE
	 12cjYC7NRK4zx0ibVCLFh8uxuCbUcSE+byNhp2g+KcBBFgWPvHas7sWeWYKz/XFl+X
	 JGD5Otbbz8BZZaxE2sAhOPOUWMub9PYN0IGUUttZ/bwPSXYT81FDiJgOJBIwPRotI1
	 1PbxS7ibVKDlssFFr5TnTpp0mgVfFikhSog/CEg/XrFuphs+dWsz/srZJWB31EIJBr
	 RX0Md9u4/CVDQ==
Message-ID: <a740a4c1-85c6-4bb5-a0cd-3203bcccaccb@kernel.org>
Date: Fri, 3 Jul 2026 11:20:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 05/18] mm/page_alloc: unify
 __alloc_frozen_pages[_nolock]_noprof()
Content-Language: en-US
To: Brendan Jackman <jackmanb@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
 Byungchul Park <byungchul@sk.com>, Ying Huang
 <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>,
 Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Clark Williams <clrkwllms@kernel.org>, Steven Rostedt <rostedt@goodmis.org>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, Gregory Price
 <gourry@gourry.net>, Alexei Starovoitov <ast@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Hao Ge <hao.ge@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-rt-devel@lists.linux.dev, derkling@google.com, reijiw@google.com,
 Yosry Ahmed <yosry@kernel.org>
References: <20260702-alloc-trylock-v4-0-0af8ff387e80@google.com>
 <20260702-alloc-trylock-v4-5-0af8ff387e80@google.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260702-alloc-trylock-v4-5-0af8ff387e80@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 358ddnrmgxoc4d8mjx3bqw4ak1tbonet
X-Rspam-User: 
X-Rspamd-Queue-Id: 781A2100007
X-Rspamd-Server: rspam05
X-HE-Tag: 1783070416-778226
X-HE-Meta: U2FsdGVkX18TgHdI1lymPL9399iEg3o/RiYSzns1C+UCH1aheHdSbaFeqComn7jx5lRQ2Jsv49t0+9xjTSGWWPYzmYoruVuUHKf4ZQftYyb4V/TTlEsGdXmYwpG5lEQ5GHlCPeSa/R57h++0+jlyGyOjKg9xRUYyc4+f+cUPqYIZUss8iROGxdN6cB5tMayFSWaRuBvFfFDPQUz8jLJJw/CKsOiFXTWnrgutejXmmJ7i4t17PLY9qx/Z8Il+HpRfsGGLxnF1D6ddvKRE6s2Vh7K0HOKYa4DK9vBkr6y9MSIuG7D8sslNdKkTiEqbn2soF3LIBE/s8neTs56iMei8ETVtpcTr6kk0GTQpF5pnPV2GAsQMii6Q6VEEkILmGcNBjvpKqJq5ysH/CiYnyq/le0Eya5fd2mpM0axHLbKbU6/kteIDrErGbbT1RmR4oZsK39z8oZFbTF7UkMZdVwsQNQMMqhVfHCRsz441WnG1XEfUGTwvGvqthzWUfB2EGQ/ijU9YBy4diTAlZPV69OZMzUxzZkQ2XxJkuaRbbCgEnrTa/+HMFA4EA/louG6XUNg81vgE7yeqJIoxvSbNQRVJjcZmGJJIa0jIYEt6thdgcJ2HJyFc7pFRTSvqAmGMCKbBiL6hDS7CyWPPte3Q2Jsrq5h4w+86xrah84B60a6w/IygrEdV+7hZdRBv4D9aZvHG9fLxL4+kBjSqTqG99lJwTsxBQsEQ04LeWGK55md2WVVTRKtdrQG/Cr61BHqpYy9nV+y/l/YDhbzoJ+f1nIYgVtJDSzn4ZzFwWupwLpRG+feFEBAIO/n2FPyGut1Di270JfTA+LaUx3hojCH/1abV1gMjaCRyemBJTBi0XmSZPTJgxdsfCOGH8AzBzbzj/J8ZDNWIc+Fu3xT/0INXkFabjJ55Xjh9cCLIw7O/bGOPM7+Son4EQvhLjJmsaatNQQGYuuXb+nhkcQiFko06qDr
 f/LIi5+8
 Aeh15o5iPIvLS8RhA1gZZ4fmNiit+ZVLawMfjuK7o9IhackSjcL/Q3TwPx2YvO5tQsUdAmv/ezKEZReptdRISurrnzZHfUptOAqCOjoW14IA/jgH2iZtYMzlou1jNpRJ5PTR0l1Ylh2EYgLNx0D4rYX9BobmzNuEMONjjqudG5zlfC5x48ttz7kn2USe7DX+tPyPMn2a7DVl24DAE8UHVaNAB5ALWiao4X3+9vfttVKi99DbF10p1GbXUxpRJGGe+dUt+jW2CjyHcIxhaQelOBygMhYPBf/keZ6gDF7lYop6qy5yVJp+sYAhOK2VbzT8U774zjj1SltBDMagY6HBJxjc5FuOfNvY1BSA8SIap4QdndmyLogFxDacx61pJD14jwyQCXh87hFYCuQgwWpbBS9oBd+kKkYeKSRM+hnR3wk3G6aQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 11:49, Brendan Jackman wrote:
> Currently the core allocator code is controlled by ALLOC_NOLOCK, but the
> main entry point function is significantly different from the normal
> __alloc_frozen_pages_nolock(), this is tiring when reading the code.
> 
> Plumb the ALLOC_NOLOCK control one layer up in the call stack: create
> an alloc_flags argument to __alloc_frozen_pages_nolock() (which is only
> exposed to mm/) and then turn the nolock variant into a thin wrapper
> that just sets that flag (as well as handling NUMA_NO_NODE, similar to
> how some of the wrappers in gfp.h do).
> 
> For consistency, set ALLOC_WMARK_MIN explicitly in fastpath_alloc_flags
> for the new ALLOC_NOLOCK path. This was already "done" silently in
> __alloc_frozen_pages_nolock_noprof(): ALLOC_WMARK_MIN is 0.
> 
> Rationale that this doesn't change anything:
> 
> 1. Simple bits: A bunch of the nolock-specific handling is just moved to
>    the new alloc_order_allowed(), alloc_nolock_allowed() and
>    gfp_nolock.
> 
> 2. __alloc_frozen_pages_noprof() has some extra logic that wasn't
>    previously in the nolock variant:
> 
>    a. Application of gfp_allowed_mask; this only affects early boot,
>       only flags that affect the slowpath get changed here, and the
>       nolock allocation path isn't allowed to the GFP_BOOT_MASK flags.
> 
>    b. Application of current_gfp_context() - also only affects the
>       slowpath
> 
> 3. The slowpath itself: this is now just explicitly skipped under
>    !ALLOC_TRYLOCK.
> 
> Ulterior motive: adding an alloc_flags arg to the allocator's
> mm-internal entrypoint can later be used to do more allocation
> customisation without needing to create new GFP flags.
> 
> No functional change intended.
> 
> Signed-off-by: Brendan Jackman <jackmanb@google.com>

LGTM
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


