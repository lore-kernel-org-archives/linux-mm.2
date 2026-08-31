Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89C25C61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 09:00:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A10A96B008C; Mon, 31 Aug 2026 05:00:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E9B06B0095; Mon, 31 Aug 2026 05:00:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 902FA6B0096; Mon, 31 Aug 2026 05:00:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DB6B6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 05:00:21 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7AB121A03F0
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:00:19 +0000 (UTC)
X-FDA: 85160968158.18.3FECA4A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id E3D4380006
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 09:00:17 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+fCunIa;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788166817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zi54Xqc9wYL4hOWczwnWfHtX2+L7V7hgC2AJ84YdNes=;
	b=2w2RT8DrF4TFflwf8X23G79uOZPELNTqZq6kBgSS5KN1+tgM/uwRNyDNvRUuS/fhyXd/8T
	rWL93KNpNJpYNdlE7zCbIOGEolbcoD7iNEQPHFx1P1+4qIKYcUTqkAf99PB9GvUSQa0Z4u
	cCZ6foSzWkUMY2fO2mmYoAc/fCAVIV0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=S+fCunIa;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788166817;
	b=SHXO/QJXnflKJbf1N/a+XtqE3/QRq6dlLtpyTIclPxBvrY1evcAOdxT7ZQpviRqKeLciHt
	fdD6DzfVwk+PYcGRDthlG2WNrI7xYk4alDuHAg/QIf1Q5T8FsXFPsFN1jnGrEvn2K44WrN
	hAkRO0Lhl2sRFMCCmfZGhJdwJI/NJWA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5479E60120;
	Mon, 31 Aug 2026 09:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 565CA1F00A3D;
	Mon, 31 Aug 2026 09:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788166817;
	bh=zi54Xqc9wYL4hOWczwnWfHtX2+L7V7hgC2AJ84YdNes=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=S+fCunIaNf5e046H2LrNrB9xa1oI+cz/7K5WGt2m+QU4J1O7Q4q4zkactYTUJjEna
	 ZXDXDWJFCZBZeMuL0R5BGFzezr7l+t10w23P8E0DgD8N36jmTndUD+3sWi1Rsw55pS
	 HnyrUy7xRo2rYW4gyiAru2sdSx/8MQT450NBHzWM7YUle6h12dUkvZvWwHWc8bbQ8+
	 RyCR7Nb0Mjx5jbjiMz2pndFw4USjQnmc7QoyWHhUBYmPaIh5QNwk/nje8pKfPjFcmS
	 ADkQaTtXqgN/JiqWTviAzOIMGEzz4xNcU6Dq7NvIiknL6i2C2NbhaLeAjeMi8pzEUE
	 CaEZzYqJDBxlQ==
Date: Mon, 31 Aug 2026 10:00:07 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Nimrod Oren <noren@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Nirmoy Das <nirmoyd@nvidia.com>, 
	Dragos Tatulea <dtatulea@nvidia.com>, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/khugepaged: cap min_free_kbytes recommendation at
 1 GiB
Message-ID: <apVCAeICeuxaL5Ed@gremlin>
References: <20260831075635.2244437-1-noren@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260831075635.2244437-1-noren@nvidia.com>
X-Stat-Signature: x96reh3ptuxbp9z1a5p4qapswsoexfos
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: E3D4380006
X-Rspam-User: 
X-HE-Tag: 1788166817-508411
X-HE-Meta: U2FsdGVkX1/jzQFUSvLlrEh3EwbqvwiITp/mWZY6VRRgWRv8nRYdEnJmyVCekhFrhBfNgbkJltsRykakUwDLgNhv/c0KwXEaUTezUZp8iKH7V/PJ8bz1F74vmRtqwtnaHiA2p851fYysCW8Kxz32KPiFKlXm6TD3CczDo32fIG2z0gozGOTuTgAkBDoLxw4wjiCm230AKKl7BBC/TQjyIio2MKR6cxA+cxS0Q5OhIBSdBB8tS21VHr4IHew+Nz9j8WNl2WdLgMj3uwvjjKMJEMjzxLbIFy/Waqeckn4OnmvUzDCEl+gzONDED8a6WKVd/AqWsF7K0OsPY9r7zS4AA/tZHU5ptkkgfgkcvK+i5GNOsdeE+3dDy0o/GdztJkdgFoW3Na+Ar3rcdRRqJy2DMNEa0PplcA/Q9Ge/StR5OyAavWOO+PQuW+8AdmPimR2sTOneN23aqRGTdRM3nV0GBZ8iqozSw7ZizYw41a/mYuHptrWqHOpp7HLW9GUH/tuVocU6RWnq2l3frPSHDFQ+yScJoqTcatEekzYOGtf5P+E2jaUpPVpbcb8V2GuMdnC61BeQfIfWGMkLJZLmoBRfGSrFLVBz+wVHiqeiM2+9SzMJYPyH2AKDvsblaB3Sp67eQ1kgNFnI/VVZuNKdgEMpG4USzFOL+gRF8/Z+s91XV0kTf9PeGWLo+cYYjAUdSWMCYAqUESn8cFaLxae0A+AhdmDYxBgjFBHV0ytU0TT7r/6S6mo5MeAzrMsocZhdcklTp7Xk+n2ZuVSNOSaqSfUkxclyP+TtXyrkumdeyLYx5LMoQWj5SR1Ns7BAU7NWko5QCBY9+Yu9s7yztmbHozaC5Eerh5BSPZNcFxZesYZj+nxMfFBMmtLIK1fbioy0QOvvTtJUqQCPyQEM9x3DVIXuWN6qv1pmeMqtXimrUnQc0Cff2VoF223zZWPndKPJHZ+Z4VLez7cy1MPUjwusTB5
 TvU67LZj
 DeQocY69R9WNsreq2zJ/wL17j17DITzWiWAwHdGD38oxCVdslNqZFFybnuV/f37JjiazNfCJ4JLncBP2vFSRrnhQZdk2giX3qqShrTlB9sWX5GJRBzF3Q0rUukznp06SN9iLqImxCY4loeK7nGfq2qYnpqyojSjmmR/Jvi9lKj4d1P8mH0ULtf8sTJdpnHHzQdSRN7zWiXyVGPtnxx11vgE5RyJnStRH7rqEsH17BkJp17FtbjWE/1F/QQXovV5vzcrQGKbCq80DjkDLz83czv99vkjSwJF7XSErxyD44Nb+glVKHB6ZooKyPKxCGCJQo3t3DecSLxeGN25sJzZYADftqv11UdCnLInkR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 10:56:35AM +0300, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> With MIGRATE_PCPTYPES equal to 3, the formula accounts for 11
> pageblocks for every eligible populated zone before capping the result
> at 5% of low memory.
>
> This is reasonable when a pageblock is 2 MiB, as on common 4 KiB page
> configurations, but scales poorly with larger base page sizes. With
> the default arm64 pageblock sizes, the contribution per eligible zone
> before the 5% cap is:
>
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
>
> Consequently, min_free_kbytes can reach excessive and unwanted levels.
>
> Add an absolute 1 GiB cap to the recommendation, in addition to the
> existing percentage cap. This bounds the automatic recommendation to a
> sane value on systems with large pageblocks while preserving existing
> behavior for typical systems with 2 MiB pageblocks.
>
> Link: https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
> Suggested-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: Nimrod Oren <noren@nvidia.com>

I do think this is a practical way of preventing runaway increase of reserves.

In the long run we need to rework the pageblock model I think, but this is
a reasonable way forward in the short-medium term.

Obviously I defer to David and the community on this if they think this is
horrible, then let's not.

But I do worry that we'll carry on with unworkably huge reserves on 64 KiB
page size while rejecting every way out until pageblocks are _entirely_
reworked to account for this (probably the long term solution).

So I think this the least-worst approach of those proposed so far for now
:) Therefore:

Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

> ---
> v2:
> * Use a named constant for the cap.
> * Drop explicit linux/sizes.h include.
> * Update min_free_kbytes documentation.
>
> v1:
> * Cap the final recommendation at 1 GiB as suggested by Lorenzo.
> https://lore.kernel.org/r/20260728202014.2517142-1-noren@nvidia.com/
>
> RFC v1:
> https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
> ---
>  Documentation/admin-guide/sysctl/vm.rst | 8 ++++++++
>  mm/khugepaged.c                         | 7 ++++++-
>  2 files changed, 14 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/sysctl/vm.rst b/Documentation/admin-guide/sysctl/vm.rst
> index 5b318d17aa4b..c0c925e6f504 100644
> --- a/Documentation/admin-guide/sysctl/vm.rst
> +++ b/Documentation/admin-guide/sysctl/vm.rst
> @@ -539,6 +539,14 @@ watermark[WMARK_MIN] value for each lowmem zone in the system.
>  Each lowmem zone gets a number of reserved free pages based
>  proportionally on its size.
>
> +When Transparent Hugepage (THP) support is enabled through global or
> +per-size controls, the kernel may raise this value automatically to
> +help keep pageblocks free and reduce fragmentation for THP allocations.
> +The automatic recommendation cannot exceed 5% of low memory or 1 GiB,
> +whichever is lower.  This limit applies only to the automatic
> +recommendation and does not constrain a higher value written by
> +userspace.
> +
>  Some minimal amount of memory is needed to satisfy PF_MEMALLOC
>  allocations; if you set this to lower than 1024KB, your system will
>  become subtly broken, and prone to deadlock under high loads.
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f49a6710933b..a8fc061d2488 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -101,6 +101,7 @@ static DEFINE_READ_MOSTLY_HASHTABLE(mm_slots_hash, MM_SLOTS_HASH_BITS);
>
>  static struct kmem_cache *mm_slot_cache __ro_after_init;
>
> +#define THP_MIN_FREE_MAX_PAGES		(SZ_1G / PAGE_SIZE)
>  #define KHUGEPAGED_MIN_MTHP_ORDER	2
>
>  struct collapse_control {
> @@ -3120,9 +3121,13 @@ void set_recommended_min_free_kbytes(void)
>  	recommended_min += pageblock_nr_pages * nr_zones *
>  			   MIGRATE_PCPTYPES * MIGRATE_PCPTYPES;
>
> -	/* don't ever allow to reserve more than 5% of the lowmem */
> +	/*
> +	 * Don't allow the THP recommendation to exceed 5% of lowmem or an
> +	 * absolute cap, whichever is smaller.
> +	 */
>  	recommended_min = min(recommended_min,
>  			      (unsigned long) nr_free_buffer_pages() / 20);
> +	recommended_min = min(recommended_min, THP_MIN_FREE_MAX_PAGES);
>  	recommended_min <<= (PAGE_SHIFT-10);
>
>  	if (recommended_min > min_free_kbytes) {
> --
> 2.45.0
>

--
Cheers, Lorenzo

