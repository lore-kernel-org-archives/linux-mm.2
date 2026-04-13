Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0703F531CB
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224096B00B3; Mon, 13 Apr 2026 16:20:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FBAB6B00B4; Mon, 13 Apr 2026 16:20:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 138986B00B5; Mon, 13 Apr 2026 16:20:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 077396B00B3
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:20:29 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ADA2BB72F4
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:20:28 +0000 (UTC)
X-FDA: 84654650136.28.80D183F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 392AB140008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:20:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dMUgBK9h;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776111626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NLcVHcvKWmcbrgR33gHCYc9nnRDShPHrweRag0w3Rss=;
	b=wB95OxWa45Y065nVJy7vPQI7uzCiY9lJeeLL8wXGV1MU3voSBp614wU0tDLtSnTtM9UgIl
	3yrmPHJiDLDIFzUpFV8qhnW6OLSrYuVW5Qoa4sVp3K3WqOLUBzETHHvFYDasOv61XeTPZo
	RG5kppQzcmN16QI3UfOsw3UbWIt2WXg=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dMUgBK9h;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776111626; a=rsa-sha256;
	cv=none;
	b=cUKcjW5JzPKjqlG/x0XdkKMgsh6I7dHOxTO5PcGQMjgZZWEIPZPqT1BKPxfqHBr+0LHfVC
	j9j4D63/Iw/qlg9TsQO0y28+8eWpPO1CpQ5kdrx0798OVHSDBAnE7Dzk++FDh/xttZmrnK
	E2NKFwl0FHZFDdVXyMfJYy9Es7fV8Kw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NLcVHcvKWmcbrgR33gHCYc9nnRDShPHrweRag0w3Rss=; b=dMUgBK9hVQVcXUT4U24DGS3kiz
	GhjKY37BWh7Jb4Fks9Pd0D3clCeD40QWA0HpurHvoHRsXZJ/IpWmvPCaV2Vboww0FQBL71Abpbgrr
	2ED5tKDObX9PFme+mVM5dtHPtBv/pKL3xOJ627FzQX/g0qkGh+PUIFb/Fx6/hkNnU42atx9J1Ftdn
	qmXI4eBd+pvfs2sXUBVj/geCsEOHcWCYydHRwRfgOPyiw0NgRAInjizITUXcz9Bt7Fn5ypTEQ6l7o
	YPsqJImx66NhuiVlkCjO16+WE70N5plOdZNpfq9oeLmoOdiJQ6/JKILn4JvRyLefnMDODtAcnbJIm
	qg5fHBaA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCNlS-0000000ETMo-0see;
	Mon, 13 Apr 2026 20:20:10 +0000
Date: Mon, 13 Apr 2026 21:20:09 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Song Liu <songliubraving@fb.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
	linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org
Subject: Re: [PATCH 7.2 v2 01/12] mm/khugepaged: remove READ_ONLY_THP_FOR_FS
 check
Message-ID: <ad1P-bfr_Vp6VdKf@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-2-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-2-ziy@nvidia.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 392AB140008
X-Stat-Signature: mptcyrqx7qfzgnksw9ntn4s51q6c8t6o
X-Rspam-User: 
X-HE-Tag: 1776111625-326108
X-HE-Meta: U2FsdGVkX19yH9K586vR6xJYqywmsGzTsc9olAmzi1+ARwl+NHHopVLanM7YRAgpFmHP4G54zvXxPt4WiT7ruV9wTmZ5j/n1bwG1OCb6cWKW2TacExFGdVolJ6l8RBrHd0cN3am6vv7RD3jNY+S52wv4gAN9QiYQ3uBIHefzS03BQ11ZrXCI4m23YBNsyU+cLGyZHPNj35IwOhlo5PW8/qoZ/MEg7eagv8cYIlv7J+mtG31FYIL6ByuYq3I7WUavJ7BQIMAdG/piBiMGcM6qOkgG21faKKNjwAUCuflcQdWQ5tWILX0YXBGQOMIXzb2TJ3gvv6ntT7xcDwZWnaB9Fyy6mXIy7JhW35TuxuNJml3BaZBdfwXjWd12CEfEU8ZwzSrMssuxH7QQBISbsMu/gbla+8OCkKirIqOc+yuNTcIVnYWLs8pBg1H+mCC0KIt+xetLEtBGEg+dva7txgSqWT1uHedq6dmuTzSF51E6UMUQpun09iedXlKbOM+Itfkwc7vicCiPYhX9zTJdSQCFbh2ZOHemtccUUEwEjtjFmZ5CIt0+XV7hsEvwBHSria7XM/UHpZz+t1AM5CUbpRK8koO/NadPUafQ5rR51c2kQH89ZToUUzv8H5sqDTDIX9sZR9wBczL3hINf40sliMeTZaCCdsqd05dRUhMN7isvvG9osY7fs8WYk1syT277edI/MZ5jiAc7uiQU5WQxO6NSw6bnjmDV1lo8Nz5BpSQuxFDHuonj9UFUpCU/4MPi4kvogApB9gzjDm6yXeOgSQf44vIc/olCiOcEPLED4+M/7NwEoeiWYf0QzM37mhJ8XApVtDtHAwgNP1HCG7x63IPpVI7XP4q2dl0OxxwWTla7fGVYT8fOPbLWWWA0XQsBjqptkZDwqkOYblCL1nfOlmyQOCm7JT0mA8VANgtT9cK5MJ5tafSbWr8mp2AJ9N+iQNaD0D6/yiRrQZOfGMSYR4g
 d0k6KyBB
 KiFVhrV4h45Ubcf3QiiLhpKfpf4PheG8wgLifGSR+mMf1eSg2yEwloRHZ2MqhoCsFfgPpiCp8LYQUPVw5aBHX6HMKrOjSP5i/P333JsvWLdhIj1I+qKz3JTBwtzQGdkrGnF7OyFEw1Oc1WmmmCoStzSbFYFgCFdV91/4mZBKDTWxUQE6dfQFi62/cNfs9tuzznNHmcrfQ582648625ko+jT5PzCYchAO8EautAlQYd/ZoP4wau/muSCRu2UnINehJXdj5E0dXXI3dxFk/MNkMCc0IF5Y896VZcv+v3gI9cEjRcMo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:20:19PM -0400, Zi Yan wrote:
> collapse_file() requires FSes supporting large folio with at least
> PMD_ORDER, so replace the READ_ONLY_THP_FOR_FS check with that.
> MADV_COLLAPSE ignores shmem huge config, so exclude the check for shmem.
> 
> While at it, replace VM_BUG_ON with VM_WARN_ON_ONCE.

Why?  These are bugs.  I don't think we gain anything from continuing.

> +	/*
> +	 * skip files without PMD-order folio support
> +	 * do not check shmem, since MADV_COLLAPSE ignores shmem huge config
> +	 */
> +	if (!shmem_file(file) && mapping_max_folio_order(mapping) < PMD_ORDER)
> +		return SCAN_FAIL;

I wonder if it should.  If the commit message to 5a90c155defa is
to be believed,

    Since 'deny' is for emergencies and 'force' is for testing, performance
    issues should not be a problem in real production environments, so don't
    call mapping_set_large_folios() in __shmem_get_inode() when large folio is
    disabled with mount huge=never option (default policy).

so maybe MADV_COLLAPSE should honour huge=never?
Documentation/filesystems/tmpfs.rst implies that we do!

huge=never       Do not allocate huge pages.  This is the default.
huge=always      Attempt to allocate huge page every time a new page is needed.
huge=within_size Only allocate huge page if it will be fully within i_size.
                 Also respect madvise(2) hints.
huge=advise      Only allocate huge page if requested with madvise(2).

so what's the difference between huge=never and huge=madvise?

