Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A45910D14A4
	for <linux-mm@archiver.kernel.org>; Mon, 30 Mar 2026 12:07:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C75DA6B00A5; Mon, 30 Mar 2026 08:07:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4DBF6B00A6; Mon, 30 Mar 2026 08:07:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B8AC66B00A7; Mon, 30 Mar 2026 08:07:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A7B736B00A5
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 08:07:39 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7AAEE1B8A09
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:07:39 +0000 (UTC)
X-FDA: 84602605038.11.49C590C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF7D3A0013
	for <linux-mm@kvack.org>; Mon, 30 Mar 2026 12:07:37 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hjv8PEX9;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Hjv8PEX9;
	spf=pass (imf25.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774872457; a=rsa-sha256;
	cv=none;
	b=g4lod2MDzjWcUf/Ul0YtUTO6cyouKYlmSSpSIAlKIeKFXy7yH5cEUcydlrYVtZB8cjNZaP
	aCNaKQ32os09gCR8YvdRbOkFE/Y2G8nk9+f1msg5h7ZGO4lB/6WQF2iGgM/l3aD1sbQrhl
	tklkihiEO4YrsiKTE7/GIKJn8kE8sQ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774872457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yon6I7H+AmbODvBSH4+Z9N39DqMYvOLohefrFoQS5x4=;
	b=yDICs4mZdFEVDnszqYbgjQR72OnLNK3kEHhqP+oTLaYhIBPHDhHZUYUcH78mDLkXDfH2yD
	ZCB8syszVoV/SoBFcc9c/LilEwMdLVtdNVOUY8HEx9U3HWipGB5DAVDSG5WLki9vq+QnKm
	1NTJ7N9F83zQriAM/BdCxk6JzIo450s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9B4940A69;
	Mon, 30 Mar 2026 12:07:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68CC2C4CEF7;
	Mon, 30 Mar 2026 12:07:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774872456;
	bh=707pXg4kFYwnKMDw1UsxIG7pl099kIwm4pedIii4hAw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Hjv8PEX9pAaBGbwydHervhfg035qz+u6hQdSLmYCqE9K2f8pjFBJ0zMFPyvUv9QSH
	 ph2dmLzBDDoDkTPh2/jGvX0FG7VgMzBFrtsB5scJa9bYhkmOux/IWwm9f9tyHv+BHl
	 vw4OJrTAImUx0pOlQ8Zu6sqt9VadIu02c0YjQjDsBjt0c2+3W4hnPTrfcn1SR31N9d
	 fJGBHvu1WtpaPnUl2AoLbIGeet3rZnVcTi89Ax4UghTV9zvfTI2STvR0OdaNymchVH
	 Skjz8VOsqPGWpD9BKHdbpzZlnuksjI0lX+UJcOF+gimQB/8p1d0UiLGuG6nO0ILkaJ
	 fQX3AzZehe2kg==
Message-ID: <8b6d4c2b-91fd-4e2a-9f4b-e90cb134219e@kernel.org>
Date: Mon, 30 Mar 2026 14:07:32 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory_hotplug: maintain N_NORMAL_MEMORY during
 hotplug
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, david@kernel.org, osalvador@suse.de,
 akpm@linux-foundation.org
Cc: vbabka@suse.cz, harry.yoo@oracle.com, joshua.hahnjy@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-cxl@vger.kernel.org
References: <20260330035941.518186-1-hao.li@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260330035941.518186-1-hao.li@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AF7D3A0013
X-Stat-Signature: k3a1orh6hb8ex7uohserdfpswhmgg6x1
X-Rspam-User: 
X-HE-Tag: 1774872457-909765
X-HE-Meta: U2FsdGVkX19xauoA1R1xceCgu9vGuARflyKERPW3C+e6C2zH4SAB+MgbB6H8CH8TDQY29tI8GJda3yZrL8dSRoU+xDsvyq/1Oq/L2iJBG+g1GDrNkiQJmJLW99JT9arqmNbtGz1j4TNheov1qx5+PWOyLrLmUJ5hMmQU17b7Sg8dOgBjxX5V1D1AkJJnqkIh30yq+YB5CSZmmJKlDcvlXt8pev+ef+Xrd6jsT7uFZTQvpjFx8B9K8mduRLtez2CjrCKHqsg3yQAt3oXUaIJwKzW5AdkEfb3npMU3WUkVInSTOvrk3zHvXABF+cT1THaM8Maph6hKPP6whG2mK73sPZJonw2ceb2lyE5qPuvjSXDIiWu8a19Oo5Hv1qltD+TcafI65vWYm7vwWMfmkUK45SR2pm/jyYCp3SqiZy34A8PhPQJ8w/Rp18wClA0vUNoi8eubxSi0o5ndYYL+ooZqKMK8Ky+KUFqMI2sKkjz2SGkJNeD7Y6jpvcKp47BAAMGm6maem8z8hw6xY7d6r7ml08kMlP1YCxW0sIF6ilDxWehp3NiAAdjBAJDjgbcVAkYY6avI4zO1SNZnuzNf/csh/jJHpd+GFA9d7YSFl79D21+mIxcNbL0DIfmuyqCbRbFr1rz76cHqsJ7jEnFngxOHdC3PSnynp+hJYhnLdTo8LVgWPi9VK4EUN9Z/g3ZoQE7moSyba1dCzBUusfwSq9dDXO1OOaWKnlJIysUDikXeWskqk9oOX3kNSnEmZgAfahm2Pkmln7uIdDQgX8dUQ+jKXO1r3uoJzNvkxHu84OCcKZ3bwohstv5TuYll+htJsG2FM/9umLtYhgWracB47D91Kq/zBhWv4eLc7rwhRq3iSAgF77/8tN8aHvim20b+vHNkWJv9umry9r9eAuF1xtLJwsAm2NwqKiMRFA4CjcRUwWrn3d3YFJ8tFbYKwPe8F5xOksVSJPUAtPv+uQVFu69
 ibgztAAC
 YE+YA+hgr2fm0RZRoDtEzqGVoRKVQd1PamnCpv1UQd7F9FNxaytLS9vyb3e2R0MrEnJ0u833EPCuAREkj7JJ++DGi3U1dVrEOj/R0iIrB1JKiQZe9NMOS5sKQ/CGgBJzop3GCfNMKIK9G8cI4k/Dt2QuW2eMjHmZFu5nGw1OE/cm4uFKT9CxXBhsJ9Wzby7hhL3+P4KK15K8c48XUK51EpAjeRzXMVX8Mui+7D7mngTLimX8WAyA5Ca6R+uVfaqrSAH9MgUS8mNqvS4CgGy4vpYBszgIZsynXwXnet4odUi7aqgJ7+ldumyOQQ6W9UIXEeBhwYohBwX5BzMbjcW0Yo7qQN6u2tbz/ZEqFKyxIwC35dZcuspYB+SgpwkuB9ttzymMslOwkayqkuEkN2lo5fJ+JwzJnU1CEIb3JEf22EEV/hJv0pypsUBSVzg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/30/26 05:57, Hao Li wrote:
> N_NORMAL_MEMORY is initialized from zone population at boot, but memory
> hotplug currently only updates N_MEMORY. As a result, a node that gains
> normal memory via hotplug can remain invisible to users iterating over
> N_NORMAL_MEMORY, while a node that loses its last normal memory can stay
> incorrectly marked as such.
> 
> Restore N_NORMAL_MEMORY maintenance directly in online_pages() and
> offline_pages(). Set the bit when a node that currently lacks normal
> memory onlines pages into a zone <= ZONE_NORMAL, and clear it when
> offlining removes the last present pages from zones <= ZONE_NORMAL.
> 
> This restores the intended semantics without bringing back the old
> status_change_nid_normal notifier plumbing which was removed in
> 8d2882a8edb8.
> 
> Current users that benefit include list_lru, zswap, nfsd filecache,
> hugetlb_cgroup, and has_normal_memory sysfs reporting.
> 
> Fixes: 8d2882a8edb8 ("mm,memory_hotplug: remove status_change_nid_normal and update documentation")
> Signed-off-by: Hao Li <hao.li@linux.dev>

Acked-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

Thanks!

> ---
> Changes: simplify the code. (Thanks Joshua and David)
> ---
>  mm/memory_hotplug.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bc805029da51..05a47953ef21 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -1209,6 +1209,13 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  
>  	if (node_arg.nid >= 0)
>  		node_set_state(nid, N_MEMORY);
> +	/*
> +	 * Check whether we are adding normal memory to the node for the first
> +	 * time.
> +	 */
> +	if (!node_state(nid, N_NORMAL_MEMORY) && zone_idx(zone) <= ZONE_NORMAL)
> +		node_set_state(nid, N_NORMAL_MEMORY);
> +
>  	if (need_zonelists_rebuild)
>  		build_all_zonelists(NULL);
>  
> @@ -1908,6 +1915,8 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  	unsigned long flags;
>  	char *reason;
>  	int ret;
> +	unsigned long normal_pages = 0;
> +	enum zone_type zt;
>  
>  	/*
>  	 * {on,off}lining is constrained to full memory sections (or more
> @@ -2055,6 +2064,17 @@ int offline_pages(unsigned long start_pfn, unsigned long nr_pages,
>  	/* reinitialise watermarks and update pcp limits */
>  	init_per_zone_wmark_min();
>  
> +	/*
> +	 * Check whether this operation removes the last normal memory from
> +	 * the node. We do this before clearing N_MEMORY to avoid the possible
> +	 * transient "!N_MEMORY && N_NORMAL_MEMORY" state.
> +	 */
> +	if (zone_idx(zone) <= ZONE_NORMAL) {
> +		for (zt = 0; zt <= ZONE_NORMAL; zt++)
> +			normal_pages += pgdat->node_zones[zt].present_pages;
> +		if (!normal_pages)
> +			node_clear_state(node, N_NORMAL_MEMORY);
> +	}
>  	/*
>  	 * Make sure to mark the node as memory-less before rebuilding the zone
>  	 * list. Otherwise this node would still appear in the fallback lists.


