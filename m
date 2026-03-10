Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F23C7FCC9D8
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 08:02:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 374856B0088; Tue, 10 Mar 2026 04:02:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F8876B0089; Tue, 10 Mar 2026 04:02:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 204696B008A; Tue, 10 Mar 2026 04:02:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 097086B0088
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 04:02:44 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4DDB88BFA1
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:02:43 +0000 (UTC)
X-FDA: 84529411806.13.2564B84
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 5261D80017
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 08:02:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s7BxM9IC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773129761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/vNC813Ci5mWIjEjqoTU9IyrUPVoqoQRgXyGJ9wmArc=;
	b=54vz8BhD7I7WT20ZoXwtgO89URyEfoH+doXh+ccI49eL/2Q1hH1uZhtsbeWEmGbYWXKIF1
	12ySqNRrlPAMNpgpYF8dthxJYsHVMGcikQubyh8PoXVOWdmzRLYpht0gbatrxfRAGZTMQE
	xlm3SYns8yOXVbxBawX4pZA6lw6YcHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773129761; a=rsa-sha256;
	cv=none;
	b=aLKcuiGKOXrXVTgSrZE8RrNJoZmtfyXKEXFq6zqWEu1aZFv9jpRqGFBL7fCToSqlEi6PYq
	D1n0SMrQOKi09Z65KLmfNAr56cT3lzXsBmqbZkMfJhnnCaQV8D2qGZSCn4hCfbvytsQ9VL
	dezyuqdxdhgKh/a6AUzw/AoMVE7HNDI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=s7BxM9IC;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DC22B444AF;
	Tue, 10 Mar 2026 08:02:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D0ECC19423;
	Tue, 10 Mar 2026 08:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773129759;
	bh=V8I3M0Bv0LCRbTF4LHTnw2/E8YY1O6TGUgahodOTqrc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=s7BxM9ICbUPacTle/92NHI3PD4PjiQ+NU8F6hb2iW+4J7NYe3dxHe2D7P2ZmWxOB+
	 WvtYUYyDYSLjkd3MkbRmHN5QAVZ+fe4ylTx+L41r3GIcEGVyYwOy9MbyNST+sK0tZK
	 3lQiLdreSlLIu9GFhd3u5De6XHVcpD2qFep3wOqFjXkhPXVnWoRYADJ4og1nZR4BL+
	 Qszp5jy7lvYL7Yu8RCnE1yPl6NJbiDGcns/T8LqtGpmB5iGwiCQ4As6hWbpDt3u+1H
	 Xj1wCTTqUnLDhIfFIUxPIOPhNnG8EvoyriYXEfsyojgU21Qwn2Hg1c/AeOZFwKIVvF
	 Jv4/o6tGYDUbw==
Date: Tue, 10 Mar 2026 08:02:29 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, axelrasmussen@google.com, 
	yuanchu@google.com, david@kernel.org, hughd@google.com, chrisl@kernel.org, 
	kasong@tencent.com, weixugc@google.com, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com, 
	harry.yoo@oracle.com, jannh@google.com, pfalcato@suse.de, 
	baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	baohua@kernel.org, youngjun.park@lge.com, ziy@nvidia.com, kas@kernel.org, 
	willy@infradead.org, yuzhao@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com
Subject: Re: [PATCH 0/9] mm/rmap: Optimize anonymous large folio unmapping
Message-ID: <032ab9a6-a49f-41c7-81fe-1c6fbaf94a79@lucifer.local>
References: <20260310073013.4069309-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260310073013.4069309-1-dev.jain@arm.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 5261D80017
X-Stat-Signature: jtnz1dpmu4ttku6hh8zyk4kkoup3owbs
X-Rspam-User: 
X-HE-Tag: 1773129761-595349
X-HE-Meta: U2FsdGVkX18JAAAPNyyMpmuUwQ/JDGXJmCvBWgFj+HavDax2E4Gm7wxrCNeXO3ZpUpR/niuynzlmhZtdY5nbTNC8Z18nYdPMuXzj5Q1LyYtHRQ2VCWGcJfKiM6TA6R23q2LdmYiPRYhE5IHWP6vXNcGRQXcdNaK8lgSEm2HVPCDS5AAwakc0vx89gCpXMO1CUSs0SE+M7jWZmpz3Gl29dKDqeLQSMq/vBn5md8jzbP1s3dpI/u4tZCgHKGV3Bv01mTWdgL8iSjtOi04St/WEU8lniFSPtHgub+taRgVAZP4PDRv3TKCNxX1eflg2+xbfKUxY2dbb+ak8O5g53upyGmiaMjF5Lz0ICTFI4roKWlSQtsu+R6a//48XbkwDFG/Na7odTINSmx0UotGnYyLq4vJkRsfPc83DcIDrIX7hge+vVOO+Thk8RtggtUNG2o2q4hc1oa2yTzfzRpQXYTe6YzShbMavyacuUfFdUeXF053lTfGqUMN96kxhtFDxsceRJI1pwgFQHaApXSa9aNuUy6yIfFgng1cOIX/ItN1JKAFqpV6JE7Ze06F+Epa0BIdNxc4EbiBlQoarDB5Hcxxu95Mw+TpazVNqAyMLVgutk0Iz6S4AhjLCZ3KL/nuWskBo/Tg2mdvGSAtmWjwLqGFRYZk/GvENiVY6M8uI1gwWhdIr2lseVcVGfFTJR2ZhWw2fd0gUnqdZaY6cTWASOz1Es2FGVzmT5xJk2bqFXaEb+OkdOI82eDjP/Jga57qyRuJ+xbcOqFDZRBuXU7sgQNfL43Huq2w+0vmkOuLo7n2zt+619I0ux8UNr2BWJfC93gVFqDwkuno/enT1oUP0Xs8NkQhy5Nf8xvTDJ47rV8OkQSAtNu2jcpx/yFZJ1uAZqMqXaAEEyaCe8aiNYDnZrOdnRvHP68fxI5+qdnZYmzF6D9LmnVZM5GVttfzfBjV9aMJiQXe/iYgyALzoWH+qSnv
 TrmUqw9W
 9SSiZOoheSFW23Ry7OZBSh9BCgilptwZCdc+w8dF2++KjZti1cwdfRQbOoISq6IDYQt3zJni2guxPRvQOwoZkjKdVRejxWZbDuDRbJji6NY6U6uDuekXFyIR2nD+p7LyLtp5Nmt0zJMueupz3buukGQ0zo+WkcYGUY2AlAg0Qy31v+jBJ7YWQbyjskBcYEvlPyCJFPOSUuLoeEd6wOUhANo/VZ4ugYON/PJpUkEJJk/9N/Li2SpEwymHvWQSfpSpco4Rs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 10, 2026 at 01:00:04PM +0530, Dev Jain wrote:
> Speed up unmapping of anonymous large folios by clearing the ptes, and
> setting swap ptes, in one go.
>
> The following benchmark (stolen from Barry at [1]) is used to measure the
> time taken to swapout 256M worth of memory backed by 64K large folios:
>
>  #define _GNU_SOURCE
>  #include <stdio.h>
>  #include <stdlib.h>
>  #include <sys/mman.h>
>  #include <string.h>
>  #include <time.h>
>  #include <unistd.h>
>  #include <errno.h>
>
>  #define SIZE_MB 256
>  #define SIZE_BYTES (SIZE_MB * 1024 * 1024)
>
>  int main() {
>      void *addr = mmap(NULL, SIZE_BYTES, PROT_READ | PROT_WRITE,
>                        MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
>      if (addr == MAP_FAILED) {
>          perror("mmap failed");
>          return 1;
>      }
>
>      memset(addr, 0, SIZE_BYTES);
>
>      struct timespec start, end;
>      clock_gettime(CLOCK_MONOTONIC, &start);
>
>      if (madvise(addr, SIZE_BYTES, MADV_PAGEOUT) != 0) {
>          perror("madvise(MADV_PAGEOUT) failed");
>          munmap(addr, SIZE_BYTES);
>          return 1;
>      }
>
>      clock_gettime(CLOCK_MONOTONIC, &end);
>
>      long duration_ns = (end.tv_sec - start.tv_sec) * 1e9 +
>                         (end.tv_nsec - start.tv_nsec);
>      printf("madvise(MADV_PAGEOUT) took %ld ns (%.3f ms)\n",
>             duration_ns, duration_ns / 1e6);
>
>      munmap(addr, SIZE_BYTES);
>      return 0;
>  }
>
> On arm64, only showing one of the middle values in the distribution:
>

This doesn't seem very statistically valid.

How about you give median, stddev etc.? Variance matters too.

> without patch:
> madvise(MADV_PAGEOUT) took 52192959 ns (52.193 ms)
>
> with patch:
> madvise(MADV_PAGEOUT) took 26676625 ns (26.677 ms)

You have a habit of only giving data on arm64, and not mentioning whether you've
tested on any other arch/setup.

I've commented on this before so I'm a bit disappointed you've done the exact
same thing here again. Especially since you've previously introduced regressions
this way.

Please can you test this on (hardware!) x86-64 _at least_ as well and confirm
you aren't regressing anything for 4K pages?

>
>
> [1] https://lore.kernel.org/all/20250513084620.58231-1-21cnbao@gmail.com/
>
> ---
> Based on mm-unstable bb420884e9e0. mm-selftests pass.
>
> Dev Jain (9):
>   mm/rmap: make nr_pages signed in try_to_unmap_one
>   mm/rmap: initialize nr_pages to 1 at loop start in try_to_unmap_one
>   mm/rmap: refactor lazyfree unmap commit path to
>     commit_ttu_lazyfree_folio()
>   mm/memory: Batch set uffd-wp markers during zapping
>   mm/rmap: batch unmap folios belonging to uffd-wp VMAs
>   mm/swapfile: Make folio_dup_swap batchable
>   mm/swapfile: Make folio_put_swap batchable
>   mm/rmap: introduce folio_try_share_anon_rmap_ptes
>   mm/rmap: enable batch unmapping of anonymous folios
>
>  include/linux/mm_inline.h  |  37 +++--
>  include/linux/page-flags.h |  11 ++
>  include/linux/rmap.h       |  38 ++++-
>  mm/internal.h              |  26 ++++
>  mm/memory.c                |  26 +---
>  mm/mprotect.c              |  17 ---
>  mm/rmap.c                  | 274 ++++++++++++++++++++++++-------------
>  mm/shmem.c                 |   8 +-
>  mm/swap.h                  |  10 +-
>  mm/swapfile.c              |  25 ++--
>  10 files changed, 298 insertions(+), 174 deletions(-)
>
> --
> 2.34.1
>

