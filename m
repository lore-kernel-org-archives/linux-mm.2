Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BE2BD3EE86
	for <linux-mm@archiver.kernel.org>; Thu, 22 Jan 2026 15:45:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AEFC06B024C; Thu, 22 Jan 2026 10:45:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9A406B024E; Thu, 22 Jan 2026 10:45:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C6806B024F; Thu, 22 Jan 2026 10:45:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89A716B024C
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 10:45:36 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 51E3C8B93E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:45:36 +0000 (UTC)
X-FDA: 84360024672.19.52A30BC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id AF14C4000E
	for <linux-mm@kvack.org>; Thu, 22 Jan 2026 15:45:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NWcEMUdh;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769096734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q1CbL/XHtt+RURvp1hInNid9ljCkKTdnXn4vd84M154=;
	b=faityLQWeTvJG8PUzF8/at0C399+6Cixh/6zl3DDwJmejdfULw/xuOUGjfkj3ACXbKDG5P
	UxIzR4GFH+FpFrIAPJddI+fDUVI64XR4CPC/zAlO+xe3yDlJVKWXKKqcsOrFrJp30IDAHu
	F6RNCNpsSGCSbGC8nGKkdFVKEKjxXV8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NWcEMUdh;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769096734; a=rsa-sha256;
	cv=none;
	b=2KpJSiIBHx1ei5RS/7RRs8/Ug8MJDnZEEOyA/i0BenCb9csou1groV0yjRrNi6SUrUJYV0
	w8dqwDvDoCS3zcAMBzXR9i3eHFFiJe4bizGvA0x597JD4ff/FS3dqNkTmzGvDxUCupoE8T
	lS+tvUYFB5Tg4ed7Z+D2kBKGPqX+1SI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E84B6011E;
	Thu, 22 Jan 2026 15:45:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BEB4C116C6;
	Thu, 22 Jan 2026 15:45:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769096733;
	bh=IEtFMgBTxuSlWSZBb+7iamkhUKr36/S0WZZoOua7U2Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NWcEMUdh5QS34sLusHqI+/BYARn57kwFbF8rP9yqxQSVYQbTThev2SdrQzP0kr839
	 nvFrSTjyQWTzTAhcZv94wXzIHasKGh8rjTvXlg3u7dzTqmgl/nOIuprC3GuEAyirQ1
	 CNQCazkH14D7dQK7xzzvQ4yCg5Zi+VXuc4EnPsQA6ZKD3AMMbZZGppdYMnf0jqjkK0
	 ph5AJzN+KilJfXaK4DxZcRxvTWanRrXl44SAgj4gun2I+Y5vi9vO/DOiTiSuKzgLxQ
	 7CfrQD/FjBBLpBkFYkpb7sNkhIA45tHlzwwUt1Ly6gzq2OQaytZbCPGuBYKIgGor5O
	 jxrtmSokqMNBA==
Date: Thu, 22 Jan 2026 17:45:27 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: memfd_luo: use memfd_alloc_file() instead of
 shmem_file_setup()
Message-ID: <aXJGF-ebj9nHBkHA@kernel.org>
References: <20260122151842.4069702-1-pratyush@kernel.org>
 <20260122151842.4069702-3-pratyush@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260122151842.4069702-3-pratyush@kernel.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: 1ow58k7m9z3okhoa5qb5867dnq7bca8x
X-Rspamd-Queue-Id: AF14C4000E
X-Rspam-User: 
X-HE-Tag: 1769096734-930531
X-HE-Meta: U2FsdGVkX1+Ujb+uCH+oQEeZzXGRPdqjdL9aHJga1kMxHDjR14qwt7ReS4NZE2txyfooDTGJC23LOjbL935vr19z9nOYG6aOxwLSHo6jjbK1LKfRtB/RE6SvoaL639XiCgXsBXAFHh/bD0MR3WtTfpUkOQm1EEXG4k43f98KeVfyzwhiR6q1SJoc99xanNSpEmEFqDoE+SJ4GxDxyt/c+O53or4IXhz1TH4GdGlvMEXz4UjktXYxUH8wNNZ6bLgfnr76kKZNQwJvweJ0aQINDt/J98lpoV/PqnFq2Su4HEMkIgBNdojn61QCSdXJjVQBM73B4cIdvzKAmjmuB77yHpYWsMtnDycNEoZdlubX4zIhgHk6I5Pxg0JvTMS3cwouK8QUTvrJiwyJgRJm9mxc2YIT3XpsFoztkqj/7axK323d7uqDtgHAStCHqe2t42heG6gn/DevV2pOfHWfARTUtWsYiHJ2XTThQwk36Far5CMDM7Gyk9Y87fTlIF/iAkpiRPLXe3weMFcEpuGRY/vlE3YgbTbXEdPODT8iskEw2GHeEKxJ5ALLT0T3+Iv7ElxArT7YMCK1u5Xuqina/UbdH2bGjYaIzC4RD9tWNnHCrQg62i1rrPvYe1eTehL0qgy+QdFuzqMWcVNiRh+vJRsAQjMw3fAwXeGT2wLC6+jW3JnUg70l1D68COcGz51D0Yr9GimebYnF0DlUT2tK8VA9dP5h5UbiP3pRrQ/xLaiVWlW3JdTGg0Pr8ldkLFlEoxxwXmVTygoT0ipmrmvw+YVa2Awr/CUMzlhQqkAYSK5rhR1qGuZB5MRSM2sO4kA29KR6sqg+FyhPBVi0hd9hD09PouF35pJRN5CeAmYJHUz8owC6pLQpIIdw43HeBgDLOPmIoVior44I7IglFq6wX3GXGHarG/aRRvqOdwEiPOXPNgUMlHlX1oVoIPVBs1tgXsKsRiMydE6hwRUByVKitw9
 rBEKhlov
 UMXcG5vd7bhbBaePxodPfyNtQaTuurRpaTFGrfETrDHN9vTzI7r5KzgihoZwXjOENKCK1t9/86ZQPwTGhNZ3qLKG8ENdlhxDUnEU8D7qMfeAj5+9AkcddZX4YYh4/s65E8ZoMX2vitsbggzJSQEJMzAIP5BvL/d50kKRBEn2vsBLRjeUnXq5Mcpm2QrO+OhJpnGnWdK0NMdCZRAMHMudPFrdDKFYy8LTY6Q6LqgHt76K5s8zxfgOGg9j9EmwlqpvxtVPc9cIjpI/9fQwd/v2znqt1B7ugpua+6SzKjKSuVBHkSGySyEviePcg7vavoZedhJ1CLRFvcdRtVH9iaknfRtg/KhqmBLbdJa3405w8hYLt5wQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 22, 2026 at 04:18:40PM +0100, Pratyush Yadav wrote:
> From: "Pratyush Yadav (Google)" <pratyush@kernel.org>
> 
> When restoring a memfd, the file is created using shmem_file_setup().
> While memfd creation also calls this function to get the file, it also
> does other things:
> 
>   1. The O_LARGEFILE flag is set on the file. If this is not done,
>   writes on the memfd exceeding 2 GiB fail.
> 
>   2. FMODE_LSEEK, FMODE_PREAD, and FMODE_PWRITE are set on the file.
>   This makes sure the file is seekable and can be used with pread() and
>   pwrite().
> 
>   3. Initializes the security field for the inode and makes sure that
>   inode creation is permitted by the security module.
> 
> Currently, none of those things are done. This means writes above 2 GiB
> fail, pread(), and pwrite() fail, and so on. lseek() happens to work
> because file_init_path() sets it because shmem defines fop->llseek.
> 
> Fix this by using memfd_alloc_file() to get the file to make sure the
> initialization sequence for normal and preserved memfd is the same.
> 
> Fixes: b3749f174d68 ("mm: memfd_luo: allow preserving memfd")
> Signed-off-by: Pratyush Yadav (Google) <pratyush@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/memfd_luo.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 4f6ba63b4310..01a72e4d3ef6 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -78,6 +78,7 @@
>  #include <linux/liveupdate.h>
>  #include <linux/shmem_fs.h>
>  #include <linux/vmalloc.h>
> +#include <linux/memfd.h>
>  #include "internal.h"
>  
>  static int memfd_luo_preserve_folios(struct file *file,
> @@ -443,8 +444,7 @@ static int memfd_luo_retrieve(struct liveupdate_file_op_args *args)
>  	if (!ser)
>  		return -EINVAL;
>  
> -	file = shmem_file_setup("", 0, VM_NORESERVE);
> -
> +	file = memfd_alloc_file("", 0);
>  	if (IS_ERR(file)) {
>  		pr_err("failed to setup file: %pe\n", file);
>  		return PTR_ERR(file);
> -- 
> 2.52.0.457.g6b5491de43-goog
> 

-- 
Sincerely yours,
Mike.

