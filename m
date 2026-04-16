Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 073FEF8D755
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 15:00:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14BB56B0005; Thu, 16 Apr 2026 11:00:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F60C6B0089; Thu, 16 Apr 2026 11:00:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00B8F6B008A; Thu, 16 Apr 2026 11:00:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E7BB16B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 11:00:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8C3B6BBC20
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:00:45 +0000 (UTC)
X-FDA: 84664730850.19.DBB64BE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id BE7721C000E
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 15:00:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UwSbvBSi;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776351643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0hD33l6NeAodFbLOBu/cQL2Ziw2Dhq18nL8kGZwsI+M=;
	b=32E7Llg+/hOaznHeKPrgSJrlja9KVPfTF3qpiZcBPb17l5yc+FCJBDatY/cGgZYGmM6Y0T
	sPnme4ice26NxcNrKixIw6i015pVBIE9gsicG/zI0JvZYBld21d0claemfZc6qPdICHqXB
	nKRlyS6arZLFqxl1uBjsrrJKJaTiInQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776351643; a=rsa-sha256;
	cv=none;
	b=TIaOki7eDy8QkvsK/VgXXmUwT+5iiJn1MMQPDj27bMDzeH72ceectuML4g9luakXMOem2k
	4FlCAYWQCYAOelQkZuezKVia57g/6hBE2mPy01lVEdIua7nBnfk6XwkAmj08zl6CA/4wc0
	RSWfs3+0HZrB6lXvnVsCZYQJNTa4Buc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UwSbvBSi;
	spf=pass (imf18.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7D3EC40327;
	Thu, 16 Apr 2026 15:00:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B3FC2BCAF;
	Thu, 16 Apr 2026 15:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776351642;
	bh=JUgUGNgPbhEBAHbcpHrlNrJNbNlPc7RtPYnZIl6AaJs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UwSbvBSi8VF3f3Tq5qpdorKIGcCcVEyMQn5IR0/uhNUFHF44DXbV9J7RD7w2qdGp3
	 g7H+22JhxJTIT68QSarpWVwYMG6oILD9LlwLOPEcJ90KdS7912K3NJX2ukivcEw21s
	 +e5Oi3qWujsjPr/V8KeFR8iszmfR2eLfsSPe00GI26iidvTiHRmNl8+wuiWJ0YCDGx
	 +I9Xdku6QxtYuUlgrBYG4FfAHUbGwLht+n+vwHGt2EgMlA5ouC6LZ5GDdUpqNehuzw
	 6ZgOqrJbVuj59hNB9qcd9DpJcBpJlsSoUwJGnOgcqb4bOB0Et4/z6FolG56MMiyb3/
	 zqIK4vTquolsA==
Date: Thu, 16 Apr 2026 18:00:33 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Alexander Graf <graf@amazon.com>,
	Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH v8 0/2] kho: add support for deferred struct page init
Message-ID: <aeD5kboEdzwuR4P_@kernel.org>
References: <20260416110654.247398-1-mclapinski@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416110654.247398-1-mclapinski@google.com>
X-Rspamd-Queue-Id: BE7721C000E
X-Rspamd-Server: rspam07
X-Stat-Signature: n9o6bg9u7jsjkw583wse7ct6qfsxhe6o
X-Rspam-User: 
X-HE-Tag: 1776351643-814457
X-HE-Meta: U2FsdGVkX18enUTrVbMQl5izqb3MNE13xV4+iAvRrNpqnml7XrQ0KE1NMHbgWAz4+NBt1OTLk+8JY0ywrfo66OYQlMXNBJB6Pm6NK5HYOVhObrnAnbTgvBKXP8UgiH2j/i64COMK4+K4FqT7lo7GBdom/xsvxCfLtVbyiuW8MiNlbrcfMQ0VrW+wDk7YOnb5BMgIJyRNRjtCTu7kWAgD3wFqqpPdU2kHAWuyet92FyciQIMmkfi96jwWlJrrTZYFz4Gf3xi2bC8tYhTKDZGmLcX9l4CoiQYgqcoZP7dO+iD3kGWZfietyeTVkQnm1/Nl8UXTj/K5Mxn3TOjexopS+lmJfGwxAN6QrjCgsfom+KbsPqDwVLXzqGywtpivjCDFdZ06giIK9ZTsloIYy+Nlw9kGQ40M9SmHOpE6mdatOCsR7DhkFskdG4kfw+yf+gCOeCu0R+/3GOZkTq8JUwMrsFoojVsGSftA/6kItqwMnJbfgsWUVQ0CY+Rj6pPqRYAgVCt3tcNnIK1xdIQRhhcnLv25cY2UrHDNGtsp1+xM1z10Gz4Sy0qMaZNWXgBivfn4Ri/ZrawbkhbSNlG1+0yPtMRDLyBST+FkQ/qYu0nAXUx4y2eZLsnN0SsGpOz0LnM04VT2Myq294ZMLRGYBGyHN5WhT+4sY0772xHDvMUWf8DOqycjkUifjFGURvgA8w6z1l3oeA5gIenmFlP78jNqDRV6LLS3tgzW6jANxKcEnbK9yRmmq1za2wHV7d08HWaUyUIZ/RyW41kFqOin1nZJx3T+9zd3rDkUPPrzW2A2wQn+fu7njl4MjT3hXJvsttS/O9410Yt4nlc36JexmWfsqaOowwM1NpCaDw8CywX0KF7CF4+Gqcher6MvnRr8B2/P8EnYFIePEcXSkohN946zmAnSuUTz0GNAhQDzWvQUngZ6Oe2Meww8HzA8OtxY1q5J17lbasBUlKyKyZklern
 QTYdy88g
 1oHjvdHDlI1yvvNdqr8Dp2O8vHL/Bep3FYt8AtdnsDuiaZGq7ECqhfPqBv6Fj57SN4iGXwh9AQj/7tL2bEzMb/cFqJLbYjRirF43Fcx4Ajq21ELeSnV4/WlS7GGu65Jiil3IAnOA1mhhlCMBhCsWXtR9AgJkeiNVKM3/CnFrvRQbFWPT+UPrezDbfFP/7paVqNjah+ujNZvX0+tCjfkzJEoiB7fUdA+8EZeQzrjYr2i7icfht9jn/vtAxzZBr9ZPTOgUk2WQOpsmXfsHtibZdSJKIPWfaq+vZt8BAF7Wl6ndCcBviBNG/taQliWLzcjJKiSwI7UOCe9OjA/7op/Rm3H16fw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 01:06:52PM +0200, Michal Clapinski wrote:
> When CONFIG_DEFERRED_STRUCT_PAGE_INIT is enabled, struct page
> initialization is deferred to parallel kthreads that run later in
> the boot process.
> 
> Currently, KHO is incompatible with DEFERRED.
> This series fixes that incompatibility.
> ---
> v8:
> - moved overriding the migratetype from init_pageblock_migratetype
>   to callsites
> v7:
> - reimplemented the initialization of kho scratch again
> v6:
> - reimplemented the initialization of kho scratch
> v5:
> - rebased
> v4:
> - added a new commit to fix deferred init of kho scratch
> - switched to ulong when refering to pfn
> v3:
> - changed commit msg
> - don't invoke early_pfn_to_nid if CONFIG_DEFERRED_STRUCT_PAGE_INIT=n
> v2:
> - updated a comment
> 
> I took Evangelos's test code:
> https://git.infradead.org/?p=users/vpetrog/linux.git;a=shortlog;h=refs/heads/kho-deferred-struct-page-init
> and then modified it to this monster test that does 2 allocations:
> at core_initcall (early) and at module_init (late). Then kexec, then
> 2 more allocations at these points, then restore the original 2, then
> kexec, then restore the other 2. Basically I test preservation of early
> and late allocation both on cold and on warm boot.
> Tested it both with and without DEFERRED.

Any chance you can clean that monster and send it as patch 3?
There's no real difference between core_initcall() and module_init() with
respect to that deferred page initialization, they both run after the
memory map is fully initialized.

> This patch probably doesn't apply onto anything currently.
> It's based on mm-new with
> "memblock: move reserve_bootmem_range() to memblock.c and make it static"
> cherrypicked from rppt/memblock.

You can base on for-next in the memblock tree:
https://git.kernel.org/pub/scm/linux/kernel/git/rppt/memblock

> Evangelos Petrongonas (1):
>   kho: make preserved pages compatible with deferred struct page init
> 
> Michal Clapinski (1):
>   kho: fix deferred initialization of scratch areas
> 
>  include/linux/memblock.h           |  7 ++--
>  kernel/liveupdate/Kconfig          |  2 --
>  kernel/liveupdate/kexec_handover.c | 52 +++++++++++++++---------------
>  mm/memblock.c                      | 41 +++++++++++------------
>  mm/mm_init.c                       | 27 +++++++++++-----
>  5 files changed, 69 insertions(+), 60 deletions(-)
> 
> -- 
> 2.54.0.rc1.555.g9c883467ad-goog
> 

-- 
Sincerely yours,
Mike.

