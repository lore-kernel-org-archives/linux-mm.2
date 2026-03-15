Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F9C9F30280
	for <linux-mm@archiver.kernel.org>; Sun, 15 Mar 2026 20:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 380CD6B009B; Sun, 15 Mar 2026 16:14:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 32E5B6B009D; Sun, 15 Mar 2026 16:14:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26A376B009F; Sun, 15 Mar 2026 16:14:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 13B636B009B
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 16:14:55 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 763241D6BD
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:14:54 +0000 (UTC)
X-FDA: 84549400908.01.114161A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id F0B0BA0006
	for <linux-mm@kvack.org>; Sun, 15 Mar 2026 20:14:51 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3013EKT;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773605692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=E2ki/vwGo7cU3SaqywsBrSqrM7JHkWcidKnwofcRC7M=;
	b=xAiK0KfCPtsAd/3zja3HT6P00FUmAISaTIPw2UUK63UPCyuWm8F3xTg/6w0QAs8Mv6LUKq
	QG9TmKpTvQKWI+8Z1UUhTrm0rVm9Pe1Jqft5PPBWSKFxkDJTObqYIFrsMVrxL7OGW2DOmH
	2IEZR8d4tO9YEG4a13a0rI0DJZHdH74=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773605692; a=rsa-sha256;
	cv=none;
	b=NozCdk7QrTj2HLEW3kU2s/NIetXZvYHj6N9wa18Dab+1TB3vjcq4Ggt+NfLjXWwHjqkwew
	advPdrz/zZZuUr9sEdLQNPAnZoRTeMG4rJMoSACVSjuvsGxFPS+gFf+zEufHSr9WYPXmxV
	WgX0bODu/N8HvSfsAoWzxvR8MfwdMBQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L3013EKT;
	spf=pass (imf25.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4AFA660008;
	Sun, 15 Mar 2026 20:14:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6421CC4CEF7;
	Sun, 15 Mar 2026 20:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773605691;
	bh=En2f87SpGqjeJA4L0F4oQmvXFvfIr6vn4EdyN9IaDsE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L3013EKTOM7JcoeF7FMTckvn3M85WdJsQnjVGSf129kiqON3uXwiHqCBMfefBllRW
	 Tm28Gx7J+Y3HVV1QVxqcTkU63UfxPOIFW+3IfuF+80vffHYzmloHVxKVFKlq2AH5pm
	 6o7PTERr8eig384l5701Pc4YEDHrm10zmC5sG9o9t6/xlC2rwIlzuI9tBvX3ieLrw/
	 ipVRU9yxyxW0GhPxYwnbhLYs7JVXS1tWtmrFuYwmba6EH1ARQjX8Abob9SjpyTyef0
	 tsqXLWs1FEpuVq+Tt9GeQn1xLf/uqT6Cr6FMTzDWlPl5tt0KPnwhtyKEUFEdO+Of8+
	 xB9bC5k3GjEww==
Date: Sun, 15 Mar 2026 20:14:47 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Kit Dallege <xaum.io@gmail.com>
Cc: akpm@linux-foundation.org, david@kernel.org, corbet@lwn.net, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Docs/mm: document Shared Memory Filesystem
Message-ID: <5a1581a3-c6da-4604-9c17-e9fdfaace94c@lucifer.local>
References: <20260314152538.100593-1-xaum.io@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260314152538.100593-1-xaum.io@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F0B0BA0006
X-Stat-Signature: n8kxfrstiw6raa1nf376sno8ikr1ydnh
X-HE-Tag: 1773605691-804001
X-HE-Meta: U2FsdGVkX1++MnYrlX7kGwp1OexzF22bpLuLTsgA9xhkY1tBxD4Ve4IgiOfHZZfaMjb09JOB+GVUHYKdFuHktsuOQ9d33inf0bHZdhkmQvBukuD7a60zh5Md/oa8z80Qfz/vUgocMWObFywipubKYxX0sGUUe2CGEXsccRGBOb8QugYDh2H17cNyx500sI4ZD+EQRpi9NFuLOzDYBjVKt+EhNAu3E60velKBoDBh1mRiF1IJ8TML8vmPqPSZq+xFMC5LVazMyxgoqkl5sBZLH3jKnVhyXN0OjdnM+wKQBRJ+g3082kudxn6c9UZJVGIO8eTkwbdEcAey/KHcntjMnb8qwf4Adou6OzCp2xRZC5UewchGDJE3VO3DdY0q0i7CftX3+IQRe4H1l19MKelGfwW50ZqKU8BV3gbt8uHVJG41IkEMMnnXyrzJ/6oMvzKrCxLGQuRNVX2cytwnh026eH8H/5AMF9M0OLQsXqNPCEiZbesl5HmCAzKa3D2gFtuH+mb9kCOk5XW0ATe4guWc21sxCBxsU4J6dhmhkDStkk4dDW00ehRX/XVUe1vc12H+qrV8Vvul32ufeY3K7R78RSMboPglBOQ2+MoP8akUWRPRZOd5TrwnAY8eLwbAWdzarZNn7FejDZk+qVD9izx2JLV+sgAsrHN0IA3XdRucmEu3nUNl4vyZjzPeVhbojPyEzKPajkjDtsPkS3KKgUkyTMNkslc+tFSb1FrD3c0XtXahIe7mXa7AxIDcPWFxyILuwqqbnF+l9vAZwwNLXOVvAV/RkDPcyjNsDeoKLS3US/yEH/F6MgI4nEriVzWu6aL0GiQtGhEz6S9vAxidszgXiUfCTa5l4KanJHeFAE1PgPw6IdB11/2UoJXa1yyE5f328oD4Zs9AA+S+i8X1h1uJ1fg6SyVAoQYBBhB5n3+79ISyd7k6yt+whCHFpZN81jn5+sNmVO/RE9C7sUVXLx7
 WdLztIiZ
 YjF1YZ7NzLPIrMZsngW0Xie+xu3j+88GGOHqVPVGH8h0MSC8elw3v3TTWUH0sNYi9pcVe75COglO4tYsVsq6Zcn6KaulCZii+e2DDovqBR54iPch1YAzB+o0M81s72Shra0lDTNIxkvmHmk/i1CRvKA7lbmgpmjcGU7a6nQ46cBSGZhoUKXzi2e7xV9mIA6FIUZ49Mie4A2UYT0uu43Wq5hx+7yxM0EyFe8IQG7socixAYdPaMzywRx7hYuCu2oK+PDvxWB3UtHZUstV/SL3ueQ/KFpeVnJPFdGGnqGCXmhTvx2rARGXHyxt6PQ381/uKigPJl1G9HhSDOtU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

NAK.

The degree of laziness here is really telling, so yet again I'm sorry I don't
believe you've put much effort into this.

You've not bothered cc'ing the right people, you didn't bother with anythign
other than a cookie-cutter commit message, there's a bunch of issues with the
docs even at a cursary glance.

On Sat, Mar 14, 2026 at 04:25:38PM +0100, Kit Dallege wrote:
> Fill in the shmfs.rst stub created in commit 481cc97349d6
> ("mm,doc: Add new documentation structure") as part of
> the structured memory management documentation following
> Mel Gorman's book outline.

>
> Signed-off-by: Kit Dallege <xaum.io@gmail.com>

NAK.

> ---
>  Documentation/mm/shmfs.rst | 114 +++++++++++++++++++++++++++++++++++++
>  1 file changed, 114 insertions(+)
>
> diff --git a/Documentation/mm/shmfs.rst b/Documentation/mm/shmfs.rst
> index 8b01ebb4c30e..1dadf9b481ce 100644
> --- a/Documentation/mm/shmfs.rst
> +++ b/Documentation/mm/shmfs.rst
> @@ -3,3 +3,117 @@
>  ========================
>  Shared Memory Filesystem
>  ========================
> +
> +The shared memory filesystem (tmpfs, also known as shmem) provides an
> +in-memory filesystem used for ``/tmp`` mounts, POSIX shared memory
> +(``shm_open()``), System V shared memory, and anonymous shared mappings
> +created with ``mmap(MAP_SHARED | MAP_ANONYMOUS)``.  The implementation is
> +in ``mm/shmem.c``.

This is already wrong.

> +
> +.. contents:: :local:
> +
> +How It Works
> +============
> +
> +tmpfs stores file contents in the page cache using swap as its backing
> +store rather than a disk filesystem.  Pages are allocated on demand when
> +written to or faulted in.  When the system is under memory pressure, tmpfs
> +pages can be swapped out just like anonymous pages.

What is a 'backing store' what is a 'disk filesystem', 'written to or faulted
in' is wrong, etc.

I won't go on.

This would become 'development by review' and you'd take up HOURS of our time
while we do the actual work.

This isn't how contributions are supposed to work.

> +
> +This design means tmpfs files consume no disk space — their size is bounded
> +only by available memory and swap.  It also means tmpfs data does not
> +survive a reboot, making it suitable for scratch data that benefits from
> +memory-speed access without needing durability.
> +
> +Each tmpfs inode tracks two key counters: allocated pages (resident in
> +memory) and swapped pages (evicted to swap).  These are maintained by
> +the ``shmem_charge()`` and ``shmem_uncharge()`` accounting functions,
> +which keep the inode's block usage consistent with the filesystem's mount
> +limits.
> +
> +Page Cache Integration
> +======================
> +
> +tmpfs uses the kernel's page cache (xarray) to index its pages by file
> +offset.  When a page is read or faulted in, the page cache is checked
> +first.  If the page has been swapped out, a swap entry is found in its
> +place, and the page is swapped back in transparently.
> +
> +When a page is added to the cache for a tmpfs file, it replaces any
> +existing swap entry at that offset.  When a page is evicted by reclaim,
> +a swap entry takes its place.  Shadow entries (see
> +Documentation/mm/page_reclaim.rst) may also be stored to support working
> +set detection.
> +
> +Swap Integration
> +================
> +
> +Under memory pressure, the reclaim path can evict tmpfs pages to swap just
> +like anonymous pages.  This is transparent to the filesystem — the page
> +cache slot simply transitions from holding a folio to holding a swap entry.
> +
> +When a process accesses a swapped-out tmpfs page, the page fault handler
> +reads the swap entry from the page cache, allocates a new page, reads the
> +data from swap, and inserts the page back into the cache.  This swap-in
> +path is specific to shmem and handles locking between concurrent faults
> +on the same page.
> +
> +Huge Page Support
> +=================
> +
> +tmpfs can allocate transparent huge pages for its files.  The ``huge=``
> +mount option controls the policy:
> +
> +- ``never``: only base pages (default).
> +- ``always``: attempt huge page allocation for every new page.
> +- ``within_size``: use huge pages only within the file's current size.
> +- ``advise``: use huge pages only for mappings with ``MADV_HUGEPAGE``.
> +
> +When a huge page is allocated but only partially used (e.g., a file is
> +smaller than a huge page), memory is wasted.  To mitigate this, tmpfs
> +registers a shrinker that identifies huge pages where the file has been
> +truncated or punched below the huge page boundary, and splits them back
> +into base pages so the unused portion can be reclaimed.
> +
> +Accounting and Limits
> +=====================
> +
> +Mount Options
> +-------------
> +
> +tmpfs mounts accept ``size=`` and ``nr_inodes=`` options that cap the
> +total blocks and inodes in the filesystem.  Every page allocation is
> +checked against the block limit; if the limit would be exceeded, the
> +allocation fails with ``ENOSPC``.
> +
> +These limits are enforced in-kernel and apply to all users of the
> +filesystem.  They can be changed at remount time.
> +
> +Quota Support
> +-------------
> +
> +With ``CONFIG_TMPFS_QUOTA``, tmpfs supports user and group quotas.  Each
> +allocated block is charged to the owning user/group, and allocations fail
> +if the quota is exceeded.  Quota state is stored in memory and does not
> +persist across mounts.
> +
> +Memory Cgroups
> +--------------
> +
> +tmpfs pages are charged to the memory cgroup of the process that
> +instantiates them.  This means tmpfs memory counts toward cgroup limits
> +and can trigger cgroup-level reclaim.  Swapping a tmpfs page out and back
> +in preserves its cgroup association.
> +
> +fallocate
> +=========
> +
> +tmpfs supports ``fallocate()`` to preallocate space for a file.
> +Preallocated pages are allocated and inserted into the page cache
> +immediately, guaranteeing that subsequent writes will not fail with
> +``ENOSPC``.
> +
> +``FALLOC_FL_PUNCH_HOLE`` is also supported: it removes pages from a range
> +of the file and returns them to the filesystem's free pool.  This is used
> +by applications that want to release portions of a tmpfs file without
> +truncating it.
> --
> 2.53.0
>
>
>

