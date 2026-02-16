Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0E3DE8383C
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 21:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBE826B0088; Mon, 16 Feb 2026 16:42:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6BF36B0089; Mon, 16 Feb 2026 16:42:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4D9D6B008A; Mon, 16 Feb 2026 16:42:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 91B316B0088
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 16:42:26 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0324E1A059C
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:42:25 +0000 (UTC)
X-FDA: 84451643892.15.F209550
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 46A7E20007
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 21:42:24 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YjWMmn0t;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771278144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoP1VbN3z+yNQ0eooX058QVJirQ0W6PbRs0jM6/T+Z4=;
	b=bH9zri0OvpHdqzTjWAHZ++RJUGsEr9XS08XRnVnAELTtbg6Fnylhg+8A2sYOFh+TJahJPs
	bQEnGF35h9vyrw+hp2WWP+kQOxDK3/H8p2xXUOxr1Ndr9np+pPqV8qov2cb+b+5fKDrJ6c
	Gf4Ih/+Vx7TuJaDb3/cxbX4mEI/EvJg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=YjWMmn0t;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771278144; a=rsa-sha256;
	cv=none;
	b=ylJir5R9KEb+kHdbAUar1x16kuPCXo6yBg+3dvB4aMLdzWm3O+Jg+9qSgLpyGVGH6T712S
	iQ48dodPkULFhSjInEToU1nwCG9sf4m0Nc0qpqZOM6/bmad0FFzhDsVJmck/rDjSm1f6l7
	ORoQ6hBnYNNc8ipe3LddV13sXXKsPmA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7980560097;
	Mon, 16 Feb 2026 21:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEE26C116C6;
	Mon, 16 Feb 2026 21:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1771278143;
	bh=pxG2R/oIRqyOnH4hhkbbvKCS8frX1294bfA4gX/512w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=YjWMmn0tghKh9oBaQL6bH1tVOUfoWNCuJsciuQDOZy4C7hfJzpiRkwKDi+UkbDVEC
	 LT8ySi0JC2Sn8ojPtBuQpLLzMNMT6ROmG5/Eqx1Z/mWal5lZVoO7AwTf38Bd9vhfWP
	 4bFqH2fsVN8P8/8E2zPzvBRjlDEM1HJT2gI9HUFo=
Date: Mon, 16 Feb 2026 13:42:22 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: kasong@tencent.com
Cc: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>,
 linux-mm@kvack.org, Chris Li <chrisl@kernel.org>, Kemeng Shi
 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Carsten Grohmann
 <mail@carstengrohmann.de>, "Rafael J. Wysocki" <rafael@kernel.org>,
 linux-kernel@vger.kernel.org, "open list:SUSPEND TO RAM"
 <linux-pm@vger.kernel.org>, Carsten Grohmann <carstengrohmann@gmx.de>,
 stable@vger.kernel.org
Subject: Re: [PATCH v4 1/3] mm, swap: speed up hibernation allocation and
 writeout
Message-Id: <20260216134222.5ec936d6503e72348227c58d@linux-foundation.org>
In-Reply-To: <20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com>
References: <20260216-hibernate-perf-v4-0-1ba9f0bf1ec9@tencent.com>
	<20260216-hibernate-perf-v4-1-1ba9f0bf1ec9@tencent.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 46A7E20007
X-Stat-Signature: ink3fkqorer35ugmu4j8gcu8a9s9ht48
X-Rspam-User: 
X-HE-Tag: 1771278144-184240
X-HE-Meta: U2FsdGVkX19UfIvS1V1a5ubi0puOjCdaaLY7pxPcAX1LQAg/MWtVpvCoxIVgNmKCphI+GnBwgkl+g925II57aXFl7oV2EVcSLuf1vaIMTjc/5Hswt9GeiPKaYP8NfAFEpkcQT+S0Ockq4sR1W19vWWmquWnKuCd4v3Xmwtzhmf/L61Ul3kJmEtLbNlgnH/RmGa5ykn0zOoBks31T7JLyhQbKcrokSql50pKC7vyOonj6OJWX5XVdjgzp5vfSvEfB/uBtaH3zs8bMVHVYxNpdfJpTQyI205wWy2KfORZPStnUbOEwOT+rykb52XN9QXKk3n42oh2RcYL4Kqs8ZOeljZXC2JP0xdVNFrdhPUWKLoL8UnzorfYhK82Fwh2pQukNfh8o9+uUSXDADsXq44F1gkJd6b71VFKIHhvXg6pz5Jk1MPV2Mke1LHCFmxnK2TMY//uFYJO4Lvjwjf4dg/8AlK3LOdosoeaBfWDRb/ofJOoW/O7Amktc2Hw/8rhRkbVq3JR2IxG5zHfEqUSmoOfukX7YKZnhYsOxavnTNYDcoUzMZE05c741CCE9cvL9K0Q2ds9LM3iheQ7JWNo5DHvxgJK+3ouvUZWFW4xJEg9XY3G38+O2lxOcvG8SAmphjmBQK16odjGmT40a+j+eEqNeiB+VVqvvytskKjpXHL1zoOrYXi3fD5a9Ma2Qunlaqzqf3rF4ljI/critdlpmLjo0fX6hhAGAn4HIvTBKTj4hxZeyDvl3wtoFuRDNI45Oro2Swbnaol5odgkyOCN3Ev6RqgPNfbKhREJwPMwRII1wxryq3JsyTykwGHMyGtHT1c3Qqi6CJN0nOZjgn+QaA07kCw+C4QZGTfBYm46wVQ/2L+w4aQkNs9mU3MdfFboGSWSlvWopE//YpqrSHuEVQFCleg9+utVhBaumnMTZwpo9J+C2JvZwnN9HwtfN+qNKypmOEZJmWfY6KtmM62JBiB2
 C73uJ/MG
 4LKid+CCkdtrWIvaWbjrwYed2nigh+C/tPNQfX+yNtPqnXH1mGVAii7Hz7J5D277hQlZ256mOjn/RsitYUGJGury2XuFV0SbV5Qar5he5yCGMD0pv9ArrIl8aGqHwoQvTk2+S5Q6yzrVuGVqMef6O8LClSB4g9C3WTEfGnice4swEwnfq74Eb8TLq3pX5Ur2Yt2VmzJkTYT6jpTii4NTRiy6CxlvJ1zi4a6NuCJYk6HFvOw5L17o4EAAiVj5pMv2MBYfXbLzgjpbyKdGBVnordTpPP+/iPFnoSRIMZ/R8JDvqKWB6dSoITUvN6M5cc+cNfppckEkXOvUNWNoGz8FGWS1uyVAzqj50heipeFQQT0+nlBZUEi1krMjjdEewflC6yFTi22pSUSDl1Ds=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 16 Feb 2026 22:58:02 +0800 Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org> wrote:

> From: Kairui Song <kasong@tencent.com>
> 
> Since commit 0ff67f990bd4 ("mm, swap: remove swap slot cache"),
> hibernation has been using the swap slot slow allocation path for
> simplification, which turns out might cause regression for some
> devices because the allocator now rotates clusters too often, leading to
> slower allocation and more random distribution of data.
> 
> Fast allocation is not complex, so implement hibernation support as
> well.
> 
> Test result with Samsung SSD 830 Series (SATA II, 3.0 Gbps) shows the
> performance is several times better [1]:
> 6.19:               324 seconds
> After this series:  35 seconds

Thanks.

I'll merge only [1/3] at this time, into mm-unstable at this time (I'll
move it to mm-unstable after resyncing mm.git with upstream).

We don't want the other two patches present during testing of this
backportable fix because doing so partially invalidates that testing -
[2/3] and[3/3] might accidentally fix issues which [1/3] added.  It happens,
occasionally.

> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1926,8 +1926,9 @@ void swap_put_entries_direct(swp_entry_t entry, int nr)
>  /* Allocate a slot for hibernation */
>  swp_entry_t swap_alloc_hibernation_slot(int type)
>  {
> -	struct swap_info_struct *si = swap_type_to_info(type);
> -	unsigned long offset;
> +	struct swap_info_struct *pcp_si, *si = swap_type_to_info(type);
> +	unsigned long pcp_offset, offset = SWAP_ENTRY_INVALID;
> +	struct swap_cluster_info *ci;
>  	swp_entry_t entry = {0};
>  
>  	if (!si)
> @@ -1937,11 +1938,21 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
>  	if (get_swap_device_info(si)) {
>  		if (si->flags & SWP_WRITEOK) {
>  			/*
> -			 * Grab the local lock to be compliant
> -			 * with swap table allocation.
> +			 * Try the local cluster first if it matches the device. If
> +			 * not, try grab a new cluster and override local cluster.
>  			 */

nanonit, worrying about 80-cols is rather old fashioned but there's no
reason to overflow 80 in a block comment!

>  			local_lock(&percpu_swap_cluster.lock);
> -			offset = cluster_alloc_swap_entry(si, NULL);
> +			pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
> +			pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
> +			if (pcp_si == si && pcp_offset) {
> +				ci = swap_cluster_lock(si, pcp_offset);
> +				if (cluster_is_usable(ci, 0))
> +					offset = alloc_swap_scan_cluster(si, ci, NULL, pcp_offset);
> +				else
> +					swap_cluster_unlock(ci);
> +			}
> +			if (!offset)
> +				offset = cluster_alloc_swap_entry(si, NULL);
>  			local_unlock(&percpu_swap_cluster.lock);
>  			if (offset)
>  				entry = swp_entry(si->type, offset);


