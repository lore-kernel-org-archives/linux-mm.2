Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41255F531CC
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:35:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B1596B00B5; Mon, 13 Apr 2026 16:35:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9620E6B00B7; Mon, 13 Apr 2026 16:35:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89EAD6B00B8; Mon, 13 Apr 2026 16:35:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7827B6B00B5
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:35:38 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 44E1B8B2B0
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:35:38 +0000 (UTC)
X-FDA: 84654688356.03.E8CF628
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id A1BF640006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:35:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jf7uu1hT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776112536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HtYokny6y9/Dl1p1xfnv9fH4Sv6CkK/mGZxE/olmdzE=;
	b=JrhRtmsWGJfgO0ifAzNKEQz2p/7iJ2AHukv6tdxqXhCpqVtGaRqxesefmvR/jMwmFgt7b3
	PWH/LAYTzmQVOpT+nvkF7v76NXUdaMWnuxHs5i6reRKWdtV53tEoReUlCgNIsmLQfM5AJ4
	HIFYaKJEGXh2hRmlNi1bGvoF1C6nMSU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776112536; a=rsa-sha256;
	cv=none;
	b=O5HjtPsG5iKuMVhcrDVmYYGs8QjL3zf0goYG4YDJhcesIteRKszBz2IWWuxNJENQeLTWTg
	fYy+FXWTNwASyC4UUPtrlEhqCUwsgK+bfzqc2vVFS6PQmlOfIoVdESZAL23Y8VlRNwI0t3
	JZM+GfJepaYfCtEGDaEnlcs70kElo2Q=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=jf7uu1hT;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HtYokny6y9/Dl1p1xfnv9fH4Sv6CkK/mGZxE/olmdzE=; b=jf7uu1hTkK2Zwo8KKL/jpCnllm
	SGc4Da5qY8GmfJl5cU3V0+CgwLIZbm9GlRAVavYLD9l2XG7QmnAQ6BblK7KRgDhDVhh5TP3hWkN0P
	ThoJDJaT8ngjJZJ5U4jJxKCcX8XvhzGnRDe9hq1OzGE6buVl5zwgfk47IKk3bfIaaSplcJctRSkDP
	XDc7z14zpX01OvUOxGOQxXNhCDbQuDlJeWDE1iR1eociaVwO6flHBQErkKXTPwghs5XeoQt4gbxK7
	Nq+2fhrFzwMOvKha4JhePdOLj5m6F/RyKNjANmNDJ0BqBn8/KpUdcRFaS0bFTDwAumZyyarpLs5PE
	wvJ4xH+Q==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wCO0G-0000000EUTe-3j3B;
	Mon, 13 Apr 2026 20:35:29 +0000
Date: Mon, 13 Apr 2026 21:35:28 +0100
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
Subject: Re: [PATCH 7.2 v2 06/12] mm: fs: remove filemap_nr_thps*() functions
 and their users
Message-ID: <ad1TkEKQ9cyzBDWp@casper.infradead.org>
References: <20260413192030.3275825-1-ziy@nvidia.com>
 <20260413192030.3275825-7-ziy@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260413192030.3275825-7-ziy@nvidia.com>
X-Rspamd-Queue-Id: A1BF640006
X-Stat-Signature: 34qtmwujh6acspzcxat56pqiqz3z8ice
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1776112536-786691
X-HE-Meta: U2FsdGVkX1/XMAX7WTgnfBtRLXjFdUjIXEdxTZzZ5KyXvgv9S/WuDjuFbr9kx/Xh0ji7RMwRvhWFKERI1TErKZDRW2m5bMMT5elDgHV4CyjX0KUSjrd7ldYZ4nmJJqYDFN8rjUNfTTPoSSg1IfNqCt0TS9kUmuuUP++D4YeQfD+OZkRXDhMuuuHf3fdNewLYtOHjf/R2hJ5e/PEsktj9Nvj9PGXswpXihOvNixV/o9ofbj757XNlyoz6dxpva9KNcNdkQKOw55OjzRIf/gfcIjk0Zn34jvbiQ+D2WeIDZ0pLAk5s7hrjc1wVldUMO81jRwE8HJiotfXkl63MH39W5kaoE3VHN/HELoxlgmamYuihMGaO+ZU/hq0OFz7tsg6R6VP/e5anpJIrmVS23y98yTUDLeqiBaSYJGNjtdpUry8dcEtig86EbqCgZw9fC5vfeA25IO8djITRwwkOa2/5W6aJT6Ft1BsNFwP8qJrVb7rqTn6Ve6HY0tDcQZwp/Wgn0kpK3DBsDbeepBV+Wv9DqEZMlYe+dKpGYbzcQvVp9GtEmRAA7yVrqevEUd+z+Rn7C1637ys757My7vYcoo6Qx9yAznfht58w0pAJcuxGkTUNb0dh79LgjQgWQC3n/eZii0WiexgE5TYre+JPqCnqXdxSVYHc9C4bdtp6d43QtUqEC0vzVhSxu9AF2DEuy8yW2ov4gdCyJz/VAxjHm5hLKbuls5y1VnGIH9bMeoa9DkfPlkdW+83bKAKtIMa3amYScrHT0llHxhPIapmlwJxwvSN9rv0yAAhSWKfUIqHWLmMmWMkk6kIpRjDUM0fIAGLC5S1Ibx8VgGGT/qYrbhHIMPJcwMUkQw5l8wmwbFrcIu/BIdI9kJvUzx9CxZNujhNjdFCiCc5mEG7G3IV1ztj9cwUsvJcOY0xZM722NOouLU13LG8WTAewmZcAj4S3gRclvVvUQq8M+ZeyCXLa9jP
 +17A4yDn
 fSzaIdkeQDD8xk+IDL6uSXsIRU/oz3Tuj9GEF1bVDXA9+rUuMpOBw1w7DDGBM9K+K3OvKojee9kNskbo+WiXM6yZTHycI8G2vKtln+H5cm0YlnqGceF0Q7Rh99upEtFcnQnM5k891K3VXCnAoBxwFCu7rEGveFwvc60Mv0KdbtcBMQUmZWkfiYNUnpxVbGayPShPDOEq4y+YbB27LYBstfg91xz3gw/Xn/uE15RZURR9omcHGMxkMFCe+cvwEabXOZekzTgBFtnG1wlaOsZBPIgIKp8FslxZRpmBBy5gYzTxIAXF1Yz+KWRznfhkYcG5Jaa8z0LoGgZcALZiaw/iRhqWmWQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 13, 2026 at 03:20:24PM -0400, Zi Yan wrote:
> They are used by READ_ONLY_THP_FOR_FS to handle writes to FSes without
> large folio support, so that read-only THPs created in these FSes are not
> seen by the FSes when the underlying fd becomes writable. Now read-only PMD
> THPs only appear in a FS with large folio support and the supported orders
> include PMD_ORDRE.
> 
> READ_ONLY_THP_FOR_FS was using mapping->nr_thps, inode->i_writecount, and
> smp_mb() to prevent writes to a read-only THP and collapsing writable
> folios into a THP. In collapse_file(), mapping->nr_thps is increased, then
> smp_mb(), and if inode->i_writecount > 0, collapse is stopped, while
> do_dentry_open() first increases inode->i_writecount, then a full memory
> fence, and if mapping->nr_thps > 0, all read-only THPs are truncated.
> 
> Now this mechanism can be removed along with READ_ONLY_THP_FOR_FS code,
> since a dirty folio check has been added after try_to_unmap() and
> try_to_unmap_flush() in collapse_file() to make sure no writable folio can
> be collapsed.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>  fs/open.c               | 27 ---------------------------
>  include/linux/pagemap.h | 29 -----------------------------
>  mm/filemap.c            |  1 -
>  mm/huge_memory.c        |  1 -
>  mm/khugepaged.c         | 28 ----------------------------
>  5 files changed, 86 deletions(-)

This is great.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

