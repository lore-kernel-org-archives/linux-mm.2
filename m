Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6E6EECD997
	for <linux-mm@archiver.kernel.org>; Thu,  5 Feb 2026 21:34:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EE5DC6B008A; Thu,  5 Feb 2026 16:34:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBD9B6B0092; Thu,  5 Feb 2026 16:34:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF4466B0093; Thu,  5 Feb 2026 16:34:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id CBF9A6B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 16:34:00 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8F22E13B7BA
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:34:00 +0000 (UTC)
X-FDA: 84411705840.10.99672B1
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8D8D040012
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 21:33:58 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KnjjFg3Z;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770327238;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+qpr3waIcmIzqz7i9F6KVzxWpJS3O2v0oEGwyPDl/Qc=;
	b=zBvorQj16TyiphxJ+UF12/GmnmUProEQt+LCzRcBX1IS0EGKcxtFfX1j1YxvBfCibbdwhR
	FPyWLyRVlxO0tS8xedbFi3EBOpkQ+zNSmr5M2xHWCLuus6h+j20LIYAR6vQ6upBWRr9CpZ
	TZfTJ7FxmDOryJBLyKH+Zh8AR5HWEWY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770327238; a=rsa-sha256;
	cv=none;
	b=OVc30kIB28V7ea+QSM7VmeWrerwzRqztVmw3CUwLv3xJRputFMhKsR6Bz9VtwXJHPzG1BW
	vwRiLPqR59MWHP6wQCHm92+VIjSmoi9eV8vfm/Mf6tl3yZVH9vqcMmzXLcL4sg4ZIiN/44
	k6/xAObvF/RZXopwzkpIU7UH2QmMG0c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=KnjjFg3Z;
	spf=pass (imf11.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Thu, 5 Feb 2026 13:33:50 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770327236;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+qpr3waIcmIzqz7i9F6KVzxWpJS3O2v0oEGwyPDl/Qc=;
	b=KnjjFg3ZoglQX/inTXLusN3966exuJUxp2WyryH2K3LXnD6N6OIeQHR3Qu5ALTGC0KkvfK
	LkUXJjI1jLCH0qdOoR1EXvIbk4bik6qKdIzt3l82icJgDAUj5Q4Aw3T6Gf9jrLlb/Gvm9Y
	5RA/xE3IcfAEvy1PHanFM9IFTKkBC7o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Nick Terrell <terrelln@fb.com>, David Sterba <dsterba@suse.com>, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm: zswap: add per-memcg stat for incompressible pages
Message-ID: <aYUKpZ8nCB6MTQGY@linux.dev>
References: <20260205053013.25134-1-jiayuan.chen@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260205053013.25134-1-jiayuan.chen@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 8D8D040012
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: gmwghxob44bfzb764kez6desbbyirjfa
X-HE-Tag: 1770327238-381746
X-HE-Meta: U2FsdGVkX1+7OQ44XDXdklgRLL90MzVWjbm/VRp7G1tpwEky03aWnaZqfv2TnZHjArS9SHPR1BW1REZWOydOZ5vWsbh56vs+tfsndMVUnG2sTgILRcCEt6sX8gXZtDZsq0QWSAkA9PQqgxigvl7z+uxZoIMp+4A25kmIgFux6MWqeGrUw0EGJniK/vzd6EjsKRGyhlqd0PSsG6XCzfHJzfdiKlWAqod65i+r/C6ysDaYKifPDBLzk6mb2k58BSeGnOaGTwwceYhRGhj8My5+sfELLco/mcrVzQzsOfPFcl/6AMu9S53Dwb0TkuWRKBm50pizlba/lURif57kE+is1ZIUi4hKEpl9CTMw71Y4HZ4U407ugo5tExwX6hSznM4bryoyD9zJF5A0Jlnmp2tfWqPrET30hl5gT3sOf3RFcf7iWCC0drK+DDyyLM9chZT2v3gOXUqWlmxUYh8OylNVMDNEVvlQBUNncTYjHznsf4vlCv1aSt4iA/qoK+mvicsy49qpzPcTEzZ/dhzwEbN+5hPAZaogSFEgnob/u6XI42KjCmgBtA3RzTToo74AvC1MrT5Uzvs+Qnjgkvg/Snv1gkKp4OlGGfwPfOXZvTwlL7qAm3YySzNBPZSmEpvCi9lEP5X82u9opR6gAc7Pbr/+5/y2Fsm4Qw55Rv8Y0ATHksxPe8lXzLsXE9wdhFkSdlhlLH1IcsBuDQdN/nk016HokrWaWBOKCuz4b/rQbbjg4VDPiYxV6oaSEdywUU4FcaLVQlY3uPzcMKowN0qq4qEMykYET9vj12mFPjxbGncX7AX0a76YDzObhfUdnUL3jcBJJSRPg1HDrBxg/OewiwoCbD/513nO5NWrxOGBDaBI01ZxydOiFyLvJw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Feb 05, 2026 at 01:30:12PM +0800, Jiayuan Chen wrote:
> From: Jiayuan Chen <jiayuan.chen@shopee.com>
> 
> The global zswap_stored_incompressible_pages counter was added in commit
> dca4437a5861 ("mm/zswap: store <PAGE_SIZE compression failed page as-is")
> to track how many pages are stored in raw (uncompressed) form in zswap.
> However, in containerized environments, knowing which cgroup is
> contributing incompressible pages is essential for effective resource
> management.
> 
> Add a new memcg stat 'zswpraw' to track incompressible pages per cgroup.
> This helps administrators and orchestrators to:
> 
> 1. Identify workloads that produce incompressible data (e.g., encrypted
>    data, already-compressed media, random data) and may not benefit from
>    zswap.
> 
> 2. Make informed decisions about workload placement - moving
>    incompressible workloads to nodes with larger swap backing devices
>    rather than relying on zswap.
> 
> 3. Debug zswap efficiency issues at the cgroup level without needing to
>    correlate global stats with individual cgroups.
> 
> While the compression ratio can be estimated from existing stats
> (zswap / zswapped * PAGE_SIZE), this doesn't distinguish between
> "uniformly poor compression" and "a few completely incompressible pages
> mixed with highly compressible ones". The zswpraw stat provides direct
> visibility into the latter case.
> 
> Changes
> -------
> 
> 1. Add zswap_is_raw() helper (include/linux/zswap.h)
>    - Abstract the PAGE_SIZE comparison logic for identifying raw entries
>    - Keep the incompressible check in one place for maintainability
> 
> 2. Add MEMCG_ZSWAP_RAW stat definition (include/linux/memcontrol.h,
>    mm/memcontrol.c)
>    - Add MEMCG_ZSWAP_RAW to memcg_stat_item enum
>    - Register in memcg_stat_items[] and memory_stats[] arrays
>    - Export as "zswpraw" in memory.stat
> 
> 3. Update statistics accounting (mm/memcontrol.c, mm/zswap.c)
>    - Track MEMCG_ZSWAP_RAW in obj_cgroup_charge/uncharge_zswap()
>    - Use zswap_is_raw() helper in zswap.c for consistency
> 
> Test
> ----
> 
> I wrote a simple test program[1] that allocates memory and compresses it
> with zstd, so kernel zswap cannot compress further.
> 
>   $ cgcreate -g memory:test
>   $ cgexec -g memory:test ./test_zswpraw &
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 0
>   zswpin 0
>   zswpout 0
>   zswpwb 0
> 
>   $ echo "100M" > /sys/fs/cgroup/test/memory.reclaim
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 104800256
>   zswpin 0
>   zswpout 51222
>   zswpwb 0
> 
>   $ pkill test_zswpraw
>   $ cat /sys/fs/cgroup/test/memory.stat | grep zswp
>   zswpraw 0
>   zswpin 1
>   zswpout 51222
>   zswpwb 0
> 
> [1] https://gist.github.com/mrpre/00432c6154250326994fbeaf62e0e6f1
> 
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>

Overall looks good but as Nhat suggested please update v2
documentation.


> ---
>  include/linux/memcontrol.h | 1 +
>  include/linux/zswap.h      | 9 +++++++++
>  mm/memcontrol.c            | 6 ++++++
>  mm/zswap.c                 | 6 +++---
>  4 files changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index b6c82c8f73e1..83d1328f81d1 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -39,6 +39,7 @@ enum memcg_stat_item {
>  	MEMCG_KMEM,
>  	MEMCG_ZSWAP_B,
>  	MEMCG_ZSWAPPED,
> +	MEMCG_ZSWAP_RAW,

Hmm I don't like the name though. How about INCOMPRESSIBLE or INCOMP for
short?


