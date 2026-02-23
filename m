Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 47BBAEA4FAE
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 11:18:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 65E8C6B0088; Mon, 23 Feb 2026 06:18:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60BAC6B008C; Mon, 23 Feb 2026 06:18:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 52EBB6B0092; Mon, 23 Feb 2026 06:18:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3496B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 06:18:18 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 073428C7B6
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:18:18 +0000 (UTC)
X-FDA: 84475472676.11.6C1F888
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 457C140004
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 11:18:16 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L9pKHQoL;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771845496;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HQsMvmVHP1EOw2tuC1g88mDSpi0AiJpDN7qfPwL0emM=;
	b=FUYLIehbZM6ngmO4Mp+jgFp8qnZKZ5LHm0N6+B/OfLA8cogqNPf+ze2um0fYdmwdF+ScxA
	sXte01/Ss1LgGO01KrWJG/vpaYDPau2OSU1+7Bd0TL3Pr95uI06KOP9seDeL/meVoWSuWy
	KL0dnlvT3r1sHpGDE3UxyXXneRBbank=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771845496; a=rsa-sha256;
	cv=none;
	b=5MJoimEwbvpncWBB6rg8Ddqhwz2MOZl9xAYECeB2s7wT4W43wb7r1Yf+fcwWj4kXZ7dGbx
	7xQKp/GV8PWcPp0EjJpZYmHuEdslx2M6hXOPNeszDeip++ktwZm0WNEPtkD/nFeu5ID/62
	KqjOUXNBz/zE3H1SX4pWi8h9FMWvUWg=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=L9pKHQoL;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5BB2D419E1;
	Mon, 23 Feb 2026 11:18:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BEB7C116C6;
	Mon, 23 Feb 2026 11:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771845495;
	bh=gTMAzkNvvCdzk2jvSyT1hq/hY5rJCtn4E+HGOBjo+ys=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=L9pKHQoLD0smM5Y95VqNZA8Dm+zB+CZoNuQysK0Oe0AZTerohXQ4D6ekrtrVWclRh
	 MrHapjS3eoeObS4fEzmR6hd8hCsPPP4hs68ILm/9Xr0SBvB9k4fE89lbrmLY1Gb40t
	 vrncgjMEMRud/WuMRl/Ix8y/CsLxHz/re3yL8boQF6/6YQRNF4U/0N8LKAfzBk0crd
	 2rNlLaBE+G2pG8yA8y+swOddxu+DRI5lMid18nfOF0yFZrrNR4gGYlHMQRkW3z1Wyi
	 ok8nArgm3j0VLhB6Y2Cf02iL7GvFdbpPpvR9ImHYzA3N251Lv/F45Ek2tp+aEJwT5y
	 76itplpdzMe6g==
Date: Mon, 23 Feb 2026 13:18:09 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2] mm: fix NULL NODE_DATA dereference for memoryless
 nodes on boot
Message-ID: <aZw3caxKhZtmJCUj@kernel.org>
References: <20260222115702.3659-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222115702.3659-1-ming.lei@redhat.com>
X-Rspamd-Queue-Id: 457C140004
X-Stat-Signature: kpgmqdb7ejqi4qmbeqxwheqxhxd7zm96
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771845496-851828
X-HE-Meta: U2FsdGVkX18NXkQjgESb6KSNOdML4+xTVtcRSnAghgjctR3d9lwSZsSIFeoUwnofnPWnDx5d3+b7zqwhKMw6tC8lYZfIZ36c4HdT4RlMj+LlNYTbCbOkLmuvLhxTlX1UObaJdSO/JnmB/dN/hQXftVKozhL4zeuls1uYikTpZ3zZ5QmNOtGCQOLVVlgIOn5XBu1HvJCFliSJWqq7yXEQnKLhRY1XE3bYHk4WxT5T+YpT1SPrhhawS4kOIDNXdrJcB96ZbDsQwHbozJyLPsEbx2IkLiIb3cOzd3t7OH+IirmVjHNyuJ/3esA/VIXbgdM2n8h4X9bf59sTH4BXIEOVtmdgr90yyTH22/MPpm5DjGYx00WW8k21w3rAbk59ThvgG1Mweci0zx1h07Mbk8UrwpE76nZa8Y08bCL93wMQXqhLf6mdWU8s5PJddUl6y6bY3EykinL1bpt0wtYDCivpLuoBjYGdyGv+OlxY5zgm/Rp5rXcaNYz85Qde4P1uzJ+1r9GoGaYB40JCu7XpxZaXEMh8smbQ8Jpul6XjWGTyq8/5LqfPXLiE6kHZulXpV71d8zyY1FjlPnbZOH4PjhTHprg0wqYMTURDzNaOM5fIueJLCwQW9PYy97vRY/hiaEHjSKshLS6QGNSYi2f6APtcN8QXF+1Ix/m6VMkQdBn399sKcK1uRThuX7fFJr1ryb+RuVljHJVRITPKsvOW9utPJHtePN7cbj3HUSnTTAqGFMzPLusQLLdxIhiMk4HUNnNVtK5p+QXudSCK6KZONYYrj9wvPGwyXgmRDa1wZ03MAjsEylA0YIgUqrmZVw6RSnpOE5k0NqQsJtC4m64BmfbDecvyNyHyWZjEnRM16PW43eYlaEQCeT31Y3/rMYizizTKczsEsNRFcTRbaAqVv6RGW9PqyQWfgfG5tU2Y1Or4KtqVwGI+ZsNsb7RjCRRuBjDeD2i5M9x4x+kzhNI34uy
 uDXmZmu5
 5Vef4eq6NqEN14m4GC9r0UrSdb3rNWzKTcoVvbF8aWshtZ46PNLHoTPGK44K3LtzaLNlnt7YsnoG01S9jTO7OPaQ2Uhg8Mm6uVaxZPNFRwHUNcZWe1G864pfPCnx/9XdmQ1NC13ePT9gGQKsSqhmnhY8vooKRdSMO/9mRZKrsbIm/KBDBHtnvbqtluzrlIu6H2B+5wtpiCsbr+7vZYDYdnhfEl3mADp5MVD3vJr9p8YkKeEF9pGI9vBIXNREajexA/VapHuJmB/FkbYo8Q4aPTw9Z1pYzzHSjrdy1Y0+rGfJlwkfDC7YRUPibupMMqM3NGE9hz2UcBYBKeitbcZbZUNZ0RIu3cwFINvq4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Feb 22, 2026 at 07:57:02PM +0800, Ming Lei wrote:
> Commit d49004c5f0c1 ("arch, mm: consolidate initialization of nodes,
> zones and memory map") moved free_area_init() from setup_arch() to
> mm_core_init_early(), which runs after setup_arch() returns.
> 
> This changed the ordering relative to init_cpu_to_node() on x86. Before
> the commit, free_area_init() ran during paging_init() (called from
> setup_arch()) *before* init_cpu_to_node(). After the commit, it runs
> *after* init_cpu_to_node().
> 
> On machines with memoryless NUMA nodes (e.g., node 0 has CPUs but no
> memory), this causes a NULL pointer dereference:
> 
>  1. numa_register_nodes() skips memoryless nodes: no alloc_node_data()
>     and no node_set_online() for them.
>  2. init_cpu_to_node() sets memoryless nodes online (they have CPUs)
>     but does not allocate NODE_DATA.
>  3. free_area_init() checks "if (!node_online(nid))" to decide whether
>     to call alloc_offline_node_data(). Since the memoryless node is now
>     online, the allocation is skipped, leaving NODE_DATA(nid) == NULL.
>  4. The immediate "pgdat = NODE_DATA(nid)" dereferences NULL.
> 
> The crash happens before console_init(), so no output is visible without
> earlyprintk. With earlyprintk enabled, the following panic is observed:
> 
>  BUG: unable to handle page fault for address: 000000000002a1e0
>  Oops: Oops: 0000 [#1] SMP NOPTI
>  RIP: 0010:free_area_init_node+0x3a/0x540
>  Call Trace:
>   <TASK>
>   free_area_init+0x331/0x4e0
>   start_kernel+0x69/0x4a0
>   x86_64_start_reservations+0x24/0x30
>   x86_64_start_kernel+0x125/0x130
>   common_startup_64+0x13e/0x148
>   </TASK>
>  Kernel panic - not syncing: Attempted to kill the idle task!
> 
> Fix this by checking "if (!NODE_DATA(nid))" instead of
> "if (!node_online(nid))". This directly tests whether the per-node data
> structure needs to be allocated, regardless of the node's online status.
> This change is also safe for non-x86 architectures as they all allocate
> NODE_DATA for every node including memoryless ones, so the check simply
> evaluates to false with no change in behavior.

This kinda means that x86 does something odd, but that's a matter for
additional rework and audit of node allocations.
 
> Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
> V2:
> 	- add commit log for non-x86 arch
> 	- add comment for code change
> 
>  mm/mm_init.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 61d983d23f55..df34797691bd 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1896,7 +1896,11 @@ static void __init free_area_init(void)
>  	for_each_node(nid) {
>  		pg_data_t *pgdat;
>  
> -		if (!node_online(nid))
> +		/*
> +		 * If an architecture has not allocated node data for
> +		 * this node, presume the node is memoryless or offline.
> +		 */
> +		if (!NODE_DATA(nid))
>  			alloc_offline_node_data(nid);
>  
>  		pgdat = NODE_DATA(nid);
> -- 
> 2.53.0
> 

-- 
Sincerely yours,
Mike.

