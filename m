Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DF55CD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 08:35:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E47626B0093; Wed, 13 May 2026 04:35:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA9BC6B0095; Wed, 13 May 2026 04:35:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C99446B0096; Wed, 13 May 2026 04:35:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B5E566B0093
	for <linux-mm@kvack.org>; Wed, 13 May 2026 04:35:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 551701C0697
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:35:43 +0000 (UTC)
X-FDA: 84761738166.03.2B12C8A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id B8342A0009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 08:35:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okH5pMZY;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778661341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OACwkajZ9Nnqo7I89ANtv0rrSw+KZ0m2b0I5x+J1shs=;
	b=baKlBBzeb/dGp3n60Nmc+oW1INO+EtE0Nhk6cedGd4/jOVF2rBNaqh72ZSmbDCbx+UZTsV
	syZBAynDwvZZ8X0S1V6OqihasodREfI/Pn0gYnti4JITTZSqTuhzdUEpGtaB42MF6FWZY5
	V+JE6Y/gyxOOUqIWNra8FxeKLpdr2BQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778661341; a=rsa-sha256;
	cv=none;
	b=1y0fIPBeFk09uVvf71o/mP5LHs5SX9JuNSpDidq/LaxTmKzJ4BaQRXCG02X86ctdpnyp4N
	Z2lzKJjVxD9vbJqhZju2EElaa79d1cbe7i7JxWCOEvWSyfzRegT4EOgwSy7x4ke9ifiCQ5
	AMWizUsnFShyOYp0MOZzNABt+DtAUkA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=okH5pMZY;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 19D42600CB;
	Wed, 13 May 2026 08:35:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1518CC2BCC7;
	Wed, 13 May 2026 08:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778661340;
	bh=CPBNlGo5Ypcm6s7Op2wNhjTQjkcN1uyUXR3OUjk+IQs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=okH5pMZYF+Mu8xh+Bp18k/i22hmItIUH0AM4q7YxBD3srb0B0gNEEHo/y2es9ziUB
	 P9azEwHOLJ0DH8bczP5zmnEIwWO0vX79XmepDrGG7UoJpvGlVkpoY0qhRl1dqc+a0O
	 Gcktb735ASZynglNRgyN6SMjeuQeQQCeWmNeRoEXyrLtqE3GjoBQyzjHtfQIf3N1PZ
	 4b5LB5SwudTdjISPJMXTTW43zxB4rJKfYYQKmhCHXO6t5pj74HzEzkyUfOryNSzMuk
	 GVoN/WDdHShXVWz4De5OttpPSlXhzZKb/nWBwRDiqycNY7f1XjbrdGxSo3EIgTQQoz
	 51tMubW8Rqo9Q==
Date: Wed, 13 May 2026 11:35:29 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "David S. Miller" <davem@davemloft.net>,
	Andreas Larsson <andreas@gaisler.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Gerald Schaefer <gerald.schaefer@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Christian Borntraeger <borntraeger@linux.ibm.com>,
	Sven Schnelle <svens@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, sparclinux@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-s390@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 5/8] mm/bootmem_info: stop marking the pgdat as NODE_INFO
Message-ID: <agQ30bbET6gHN-6K@kernel.org>
References: <20260511-bootmem_info_prep-v1-0-3fb0be6fc688@kernel.org>
 <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260511-bootmem_info_prep-v1-5-3fb0be6fc688@kernel.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B8342A0009
X-Rspam-User: 
X-Stat-Signature: 1mptkxx1xiw5u4nouxsdx4bxhzrj3o38
X-HE-Tag: 1778661341-781423
X-HE-Meta: U2FsdGVkX18HvPFgyqD815FcrymbdnpyM/WtOYh7g1DNmVTFwBLjBK+OyBwcEwXaHlOYTii82deSkipYKTaMP2RSmkUg/S/nfAUXV57ftRcntSIUxTFfCsZHwZOTUvb5IagqEvcq5ObnHs8iSSBs38o+u/jnSWPuL3HBFWoMuOamYVwDSxoRMNNyb9JBLZ4J3c7kzY8mBtPNstPg463VxsL2ui4yQ6Yhg9rdrn1VosSzQ4UFimhiXn18gFJxPhEmUNiXBEFhO3UO5YqvqQ3yWcWld74yJrtPHrKim0fyFiuAy11RMuhKnXzhO8tXM0jsAl5Ic/+5xfgLuTeUA6kqt5AoKf5FGHvkZ4PbsOrW1GTJFHYP5g9tzNDUtf4xNwDy8mD4ovKOPQfUDfOPTV4LUyBg4+jri62+nJTZYUVsZfJuMxbPdVmBYx55mAx3tBIYlA/030YpBx4oQm06dmz9txyajEuzMoBr/tz0u9AsfUvbtKpIgurF1nqyD97O+X5vFWaHA6SFwf3N5oHU/WJBnzKaMphL0WTfE4bwsvlhPVBi7GVL4twxEYO7d5UOfWI9II6TXoqmy9zzKKZdxrdA2oC+MFgJkPSrK9skmFNF0vgvfq3Sx8sANFaIkcXk9SvrdJIgEVI1JD5KSH0eGuA39CRJHdaIaKi4fSTiH+DoObsKHGExOx08mk3A9HIUnoDIU96KEfrOZN+16Qyvrg0tb3rNbsmZ4Mp12RjgTzLJzgVbMiPAtUhaU9NnAq1WKzPi1YIBlWe5m9Gu8JK2qqd1B7jCEhX+HRCIBpqMAXiQX/8pIIb8BfJlCBKILQqEJGebIjEvmeU1leD1MGC6RJx/DgMGZG/4x6lbR+S8liu6CdNuy73EhPevyluGN4olvXU7Hw4eyQE9+Wi5rQY0x45mzpTvzSjPOFUwwQY9/TeBIRFujYJ0DP2W1Tz5NWCYr9jodKo8VFQTdkeBwAOuaKc
 8tyglDqJ
 +PTeYAs9jNj7iKMI9AOnAV0HlwojkQeiGobdpGsKVGQ3SXzXtskMO3TAnxcsomMcee0e35orkFo7S2NLyMzD3Se1Z9RbCIRbWJXdlYCFPw53VNfxHJgpFmgurRI793VGWvW6qCZlEZSMQr6GTkjCYianH+4RMY+K1jbrurTG9/KZJwExHSNvow1x13sJs6e95UH3ZvAt4/S/cAVpgT3VNCAu811xG6lvaT62qMsRk1AGCbhFso18j3IZuLXrFuPORDZyq7U6vWe3kFRtJKyfrc2cdUO+LKxSL5hjJWBCAwRKVs8djLB3kqPggW3XwuzvgVfNFRtz+qXpUU4o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 11, 2026 at 04:05:33PM +0200, David Hildenbrand (Arm) wrote:
> We removed the last user of NODE_INFO in commit 119c31caa59e ("mm/sparse:
> remove !CONFIG_SPARSEMEM_VMEMMAP leftovers for CONFIG_MEMORY_HOTPLUG").
> 
> But it really was never used it besides for safety-checks ever since it was
> introduced in commit 04753278769f ("memory hotplug: register section/node
> id to free"), where we had the comment:
> 
> 	5) The node information like pgdat has similar issues. But, this
> 	   will be able to be solved too by this.
> 	   (Not implemented yet, but, remembering node id in the pages.)
> 
> Of course, that never happened, and we are not planning on freeing the
> node data (pgdat/pglist_data), during memory hotunplug.
> 
> So let's just stop marking the pgdat as NODE_INFO.
> 
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/bootmem_info.c | 9 +--------
>  1 file changed, 1 insertion(+), 8 deletions(-)
> 
> diff --git a/mm/bootmem_info.c b/mm/bootmem_info.c
> index 74c1116626c8..cce1d560f094 100644
> --- a/mm/bootmem_info.c
> +++ b/mm/bootmem_info.c
> @@ -62,15 +62,8 @@ static void __init register_page_bootmem_info_section(unsigned long start_pfn)
>  
>  void __init register_page_bootmem_info_node(struct pglist_data *pgdat)
>  {
> -	unsigned long i, pfn, end_pfn, nr_pages;
> +	unsigned long pfn, end_pfn;
>  	int node = pgdat->node_id;
> -	struct page *page;
> -
> -	nr_pages = PAGE_ALIGN(sizeof(struct pglist_data)) >> PAGE_SHIFT;
> -	page = virt_to_page(pgdat);
> -
> -	for (i = 0; i < nr_pages; i++, page++)
> -		get_page_bootmem(node, page, NODE_INFO);
>  
>  	pfn = pgdat->node_start_pfn;
>  	end_pfn = pgdat_end_pfn(pgdat);
> 
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

