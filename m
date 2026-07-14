Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 80178C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 08:24:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4E36B008A; Tue, 14 Jul 2026 04:24:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D1016B008C; Tue, 14 Jul 2026 04:24:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BBB26B0096; Tue, 14 Jul 2026 04:24:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 577406B008A
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 04:24:41 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CE078A02BF
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:24:40 +0000 (UTC)
X-FDA: 84986695920.09.EFF2DBD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 241FB180004
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:24:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqG70l5h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784017479;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbuLAjCoX2Tf2xn8G6n1Bh/HGLghJUpzugxizUSUcMU=;
	b=ZT9PwhXfYX9Q9kz1aR7EeDVvyGGd8Bypgch7/D5kr36wKS5R6IMGyur0dm/hGTqfeKzIRd
	3q2OJ+rCDe6TtoPWjjd/j19Lc7bsxOrQ6iFciHGwccElEPVEU8xIk/E0Gna7J9OdJUZLfz
	75+FRlgwaIpx2hj0Fu07meYZpaLJfHM=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NqG70l5h;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf06.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784017479;
	b=rzjEO3Sfs3GPeKkpqgY8Lvvw99MPoNmFlNad8bhbxXQS7su4nCnr5AzM0aR1MFbvl4usc4
	lnR59SNW51JtK6iXymN+QBO1VYJ7DHsTMP5uG25qZ41oL635Pc0jjZgtCDacsLz/yIMrO6
	pWErTBR1ZJU4I6ksjgWXqipf3gOQEKA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7C977601EC;
	Tue, 14 Jul 2026 08:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A3B41F000E9;
	Tue, 14 Jul 2026 08:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784017478;
	bh=bbuLAjCoX2Tf2xn8G6n1Bh/HGLghJUpzugxizUSUcMU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NqG70l5hvvJ5SeDUUhXjDmxaW+OF2x1POiWfWXDReY39GbSmsmzqf2C9koMNrg3lm
	 H7eYQChV3ZrCOmxu2p0sCBYTkJJ6JC5Nov2VZJ9dK5S5rXxltZTlDkn/wTk1PmaIyh
	 x+qQ0HAMfQBUe5fvdTB5R2TWmvQoBMVDLofQ7MjdHi9yG42ksE0I3PKIzkR5+jwYCt
	 3aaGJw21Bvf3sjQg8begs7HhaTIFlE5C/e6+ZzbLGJNu0v6Sv+Tuwc9witph46K4nu
	 s8U70sRdEBRvb9Dkci26XqJSrT3Mxz/Fw90KdjoxP1VQjag35pUzXJFifZotgZpjvE
	 P+dIJ71kQ1YZw==
Message-ID: <21007313-40dc-46fb-bbf2-453c8eedf3e8@kernel.org>
Date: Tue, 14 Jul 2026 10:24:33 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 9/9] mm/page_owner: use memcg_data snapshot to avoid
 TOCTOU in print_page_owner_memcg()
To: Ye Liu <ye.liu@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Zi Yan <ziy@nvidia.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260714015117.78351-1-ye.liu@linux.dev>
 <20260714015117.78351-10-ye.liu@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Content-Language: en-US
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260714015117.78351-10-ye.liu@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: stsaoj4u68y9nnbq1iwi1aecdexc8yu6
X-Rspamd-Queue-Id: 241FB180004
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784017478-1099
X-HE-Meta: U2FsdGVkX1/XKPCgQ1nzD2EOUjm21Vfa5Vc3emmSUt6mjtLt8BjqynZ1f4o3SVWZn17JiWwEIzSXPVv/nO4JAfuoRJcPmBJFsDTFqAlFSkM0BNkchLq6yHvNJQqsjdLYJ+G9DPqKTUmXyYCg07/Luzd8jAMgKtYORL+MVunv3a39TF7bofTYYfJZPUUqfkkyc4h2UxuJV8krV0TUyZKlXHp0ZhF36V/BgAKol62v9t2FKzZcqVjRcligvP9udyWlPca0sh8zIvYQhhsm/HMPGuCJe0GN7Hgkow6lZebp3iXDjXCfAYvIE+GC0sAn1VvZKPRCekZKm6tGkO+cW7eaoGSb9zrvA3OYW2fMDu3cv+e+QCa0TFA6BAOuNgUudmhzzA8Q0AHrdQqgOa1mFWR/3KfoV5/mqc6AlGzgyiYvNW2fLY23d8WOk1mr1hG8PEfKH4ftIYj2YMdGhukakh1qoCSD8I1tLNjQqZ1NhSfD4fY/2fVYI7KSH5LTFtS1IpIdVbWcjJYrb9Wze3r7JGxgQRLyCeoZSLVnJAh0QrLDwL4WTC87OF5QUi/BPwAOWX2xBuPrijmNTVV511KF4r/2WejKnRZoI8tvU8LkDY12lpWwtpNeg4HfFQZS2LkJCGQkFfKwJvguMxl2vzOgdkIuwMNYhofemf1yQBdwce0zogoAJgKsxyJvjqgXLtgqYXVE+V4H/e+9+6y2dP8V37+V0C/dMfdzceK0pha+kpzzBz6c0IWuD9OMLq5E4jMOqYkB+90AEFhyViI74W3Uq6flJxnDoXYLz/GCwOmBpT0jzkTQ2ITlktzZD1DxQgCmUMZRMq30MMVvKzzPF+jqxqyyat30+D59j7v5SoCzYbpCdOUGWumrqhlodq5F3lawR6nRnP+/p39eHzuk0ackq/waIm7CAERRM4XwQ1bfptIhRcONcWHJZlJYdVhyvpe5x0s66olnkDVzgmPo6Mnlpo7
 SFM24XIt
 d1+GyS85sCrnMGs1NtqKRdvKpVigGwIGXozeyWuD4t6OAcplBVBPIqN1i2MPo6Y2Qixsn8fsLnYLiE3JF6f5adqd9BM8uuOfZPSLNzxX7mPiiyo/9iiNxzcpVyO8PNBYtrYG9viZitkUjNdPLYc+p/jyLQjQtHVnmNSjrCkUKOC05yfWVdD3nuKhuaW8vbqXhYgO12Q66WhGse8lIW1IxH8ruo5Q48W15ACnfql5D3sS4tjx6hDWosIhsRcm3ECgeENyZx2i0Q8oRuMnZMB+dtMciig74fAkJf7JML4tS5a9OsNxym/YSYsNeG+mwMUmBLeNNRxxiWVGUCd8+NfOGsTDLDYfHjh9C/QLE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/14/26 03:51, Ye Liu wrote:
> print_page_owner_memcg() takes a snapshot of page->memcg_data via
> READ_ONCE at the top of the function and guards against tail pages and
> NULL memcg_data.  However, it later calls two functions that re-read
> page->memcg_data locklessly:
> 
>   1) page_memcg_check(page) — re-reads page->memcg_data;
>   2) PageMemcgKmem(page) — calls folio_memcg_kmem(), which re-reads
>      folio->memcg_data and folio->page->compound_head, wrapping both
>      in VM_BUG_ON assertions:
> 
>         VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>         VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
> 
> If the page is concurrently freed and reallocated as a THP tail page
> or a slab page between the initial guards and these later calls, the
> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
> causing a kernel panic.
> 
> Fix both TOCTOU issues by using the memcg_data snapshot throughout:
>   - Extract objcg from the snapshot via objcg = (void *)(memcg_data &
>     ~OBJEXTS_FLAGS_MASK) instead of calling page_memcg_check(page);
>   - Test (memcg_data & MEMCG_DATA_KMEM) instead of calling
>     PageMemcgKmem(page), which is semantically equivalent:
>     PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data &
>     MEMCG_DATA_KMEM.
>   - When memcg_data has MEMCG_DATA_OBJEXTS set, early-return after
>     printing "Slab cache page\n" since objcg != memcg for slab pages
>     and there is no meaningful cgroup to look up.

These points have too much detail that's already in the code. Would just
mention that we opencode applicable parts of page_memcg_check() and
PageMemcgKmem() using the snapshot?

> This avoids both TOCTOU windows and the assertions entirely.
> 
> Signed-off-by: Ye Liu <ye.liu@linux.dev>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Was all of this reported by sashiko? At least the new-in-v6 was?
Then:

Reported-by: Sashiko <sashiko-bot@kernel.org>

But it's no longer a cleanup but a fix, so probably this?

Fixes: fcf8935832b8 ("mm/page_owner: print memcg information")
Cc: stable@vger.kernel.org

It's not fixing a new regression so I think it's fine to keep it part of
this series for next release and not need to split out for mm-hotfixes.

> ---
> Changes in v6:
> - Rename patch to cover both TOCTOU fixes rather than only
>   PageMemcgKmem().
> - Also replace page_memcg_check(page) with extracting objcg from the
>   memcg_data snapshot to fix a second TOCTOU issue.
> - Add early return for the MEMCG_DATA_OBJEXTS (slab) case since
>   objcg != memcg for slab pages and there is no cgroup to look up.
> - Update commit message to cover all changes.
> - Link: https://lore.kernel.org/all/20260701061101.344679-10-ye.liu@linux.dev/
>  mm/page_owner.c | 10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/page_owner.c b/mm/page_owner.c
> index 2e3880053a34..e18512a49e38 100644
> --- a/mm/page_owner.c
> +++ b/mm/page_owner.c
> @@ -540,6 +540,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>  					 struct page *page)
>  {
>  	unsigned long memcg_data;
> +	struct obj_cgroup *objcg;
>  	struct mem_cgroup *memcg;
>  	bool online;
>  	char name[80];
> @@ -549,11 +550,14 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>  	if (!memcg_data || PageTail(page))
>  		goto out_unlock;
>  
> -	if (memcg_data & MEMCG_DATA_OBJEXTS)
> +	if (memcg_data & MEMCG_DATA_OBJEXTS) {
>  		ret += scnprintf(kbuf + ret, count - ret,
>  				"Slab cache page\n");
> +		goto out_unlock;
> +	}
>  
> -	memcg = page_memcg_check(page);
> +	objcg = (void *)(memcg_data & ~OBJEXTS_FLAGS_MASK);
> +	memcg = objcg ? obj_cgroup_memcg(objcg) : NULL;
>  	if (!memcg)
>  		goto out_unlock;
>  
> @@ -561,7 +565,7 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
>  	cgroup_name(memcg->css.cgroup, name, sizeof(name));
>  	ret += scnprintf(kbuf + ret, count - ret,
>  			"Charged %sto %smemcg %s\n",
> -			PageMemcgKmem(page) ? "(via objcg) " : "",
> +			(memcg_data & MEMCG_DATA_KMEM) ? "(via objcg) " : "",
>  			online ? "" : "offline ",
>  			name);
>  out_unlock:


