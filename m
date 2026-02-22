Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5D62CC624D8
	for <linux-mm@archiver.kernel.org>; Sun, 22 Feb 2026 11:21:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 295596B0088; Sun, 22 Feb 2026 06:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 243996B0089; Sun, 22 Feb 2026 06:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150586B008A; Sun, 22 Feb 2026 06:21:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0000A6B0088
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 06:21:50 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 833531B636F
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 11:21:50 +0000 (UTC)
X-FDA: 84471852780.09.7B561EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 1BBAF1A0006
	for <linux-mm@kvack.org>; Sun, 22 Feb 2026 11:21:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=osR3VlYv;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771759309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSSj617lXMhnV2EogITnwXK0Y2+LSWsFfAbt03jGlho=;
	b=O0DnQ1T3amx2zJ9adDejAPX93plPZtWbWVEp9YNMhX8ZTlTLFPM1QQkYpDxCmCVOOjZu38
	CtMfMSQl3jw0M/VBV4+55NRfq1paSOhljdtSW39RFGn2PpvEBhAZyDaHjRHPeRCMzk95yG
	rxscTj4LpuaxipKYCzt4kMZeajQzuaE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771759309; a=rsa-sha256;
	cv=none;
	b=ejM751tlpFZFqXz43Li0bm7Rye8UO2I+vqyxX2po5eD6mT5BhLlsBqMd3ZnlJTYVAUydea
	dW3eb30YYsHFmLJBH7iSgNFYoNSxW7XJYxFyoMkhwqILTj0GGXcaFhXDQ4FdaVHp8kntLm
	jcg/hKxgNifEYAWZtNvf/DRpfitfx5k=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=osR3VlYv;
	spf=pass (imf19.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 5503C6001D;
	Sun, 22 Feb 2026 11:21:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B6EEC116D0;
	Sun, 22 Feb 2026 11:21:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771759308;
	bh=rkrhZGxSd+VBHZf31FNAsyPioRj1tB6aNXODDsIAcP4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=osR3VlYv7t2cMCbTPEGsUPqhC4nyac/EXxZBRzSYJHvLAp+YtCOJoLdlf7eCkV2PN
	 XV+cBJqFE5Ems2zjJkr0+GMbIOLfMuSQoayo8dGSO8sK/ZARKRaaL9WZsaSljegEZJ
	 NYaPewK5pMWpmYRMYFOL9C3bmYe2885ba9iXAbVxbB4E5g2wEJ7H65V5aCmDlSSjl0
	 yIjo1X3lEu/SMyt03CZxu+J3vGvG2zSxFSPu+C1flNPEYEvslLiBm7c6apPL9KxJoC
	 b+W9lxDpY0zafx6k1Zi02iu21yTvmDB0vTTUCg0MM6UeUfFn5o0j9NsD5vl/N1TeLz
	 dvf2ppJM/b4fw==
Date: Sun, 22 Feb 2026 13:21:42 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Ming Lei <ming.lei@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: fix NULL NODE_DATA dereference for memoryless nodes
 on boot
Message-ID: <aZrmxmxyLhm_Cq0Q@kernel.org>
References: <20260222054451.3261-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260222054451.3261-1-ming.lei@redhat.com>
X-Rspamd-Queue-Id: 1BBAF1A0006
X-Stat-Signature: ybc4dk5ttrnhei7z1ke9488m3midk9u6
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1771759308-208801
X-HE-Meta: U2FsdGVkX195ceIIBVUBx6R+WA1XeRAV78IHK9+lVCeGkKsRzrV3bND1xsvdCDGAuo3h2IeeLhSqxbqUedmlojcWiakuUyAb2Zv29tCovnicH0pbd6a5HhF882KTf+ZuYfoY1D07scBupVWePsxGv2XyXQK87rjZqjPOAIj767jZiqSs5Rki1nfpL+wA2CDTfZ5uMSf7r9pqm4Q4o6PaSSpOBWiiyL3oTk06OEvIwGy28meA2vEsaDO90T2hB81GBDdKZaC8mnrKFwBDXvbkbwuUSUyB4sDzp3y+Y9L1Z3Dkte9I3iHbC31jDIa3pJiLJtLE+TstQ0atUY78N5G5fkiBmZdC6wLKQSMw3jvfd75fFThj1BhSMpjQsAvza6KIKh9mQ8QnnK18vMirU/DN+1lTDvVY6ZT++0o1JrwT1ruRPRgz9G41tXd5TxWKRs94VaRecV8PEAY4flPgYCYqKGY+SoLjmoWrVanQMnPjaJWXuCJRQFZ/aeAb15E97YKuoTfhEJrtNXNMrMw8fwDhs2vxgdcDE6uDjSjHO+OKZBP7XkAcfABRS+IpoqBbV/4QN96oQ7jBGHC5OGnFLJJWXBBt8UZ23Yh8N1ENeldjPnGB55HPzrgahYxpx389fJyzc/NfQMQquemdCimnEJCkOijBZ4tWtFgxMTUnZ2UPimfIVQC/ec9ILnL1FlStY6vCTo8PWf9bjWH2komfX1EcRJMM1L1/KdFkwuZh6BZICDxSvXa1r3vSJkcnWTsIaSBIKJ/64b/J81DGZJJEk0+0pReKTtXAaECrkEhSFbXdgjhlX3bbwwEfDvIqA1R/b4AFUhFc8gH4QCPOnDI5IepmVALkfCUmmkDetSYQD37YqgRSi+p2VxB8ooS8FRfAwWQh49b+86csxvfYmwk8YtzCXyMWHaZFDw3dk7zhw8HikFCGjdqi567yta/jya5v7CXq0DxakvlV2XN8HuGuIEu
 kBNqfpbx
 0Bz7t
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Sun, Feb 22, 2026 at 01:44:51PM +0800, Ming Lei wrote:
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
 
I believe that this change is fine for !x86 as well, but it deserves a
sentence in the commit log.

> Cc: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Fixes: d49004c5f0c1 ("arch, mm: consolidate initialization of nodes, zones and memory map")
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  mm/mm_init.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 61d983d23f55..9d63cab36204 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1896,7 +1896,7 @@ static void __init free_area_init(void)
>  	for_each_node(nid) {
>  		pg_data_t *pgdat;
>  
> -		if (!node_online(nid))
> +		if (!NODE_DATA(nid))
>  			alloc_offline_node_data(nid);

A comment that says that if an architecture didn't allocate node data, we
presume that the node is memoryless and offline would be nice here.

>  
>  		pgdat = NODE_DATA(nid);
> -- 
> 2.52.0
> 

-- 
Sincerely yours,
Mike.

