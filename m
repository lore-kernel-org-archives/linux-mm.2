Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6759CCF9F8
	for <linux-mm@archiver.kernel.org>; Sat,  8 Nov 2025 02:26:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0E29E8E0018; Fri,  7 Nov 2025 21:26:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB488E0006; Fri,  7 Nov 2025 21:26:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F39708E0018; Fri,  7 Nov 2025 21:26:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DF3928E0006
	for <linux-mm@kvack.org>; Fri,  7 Nov 2025 21:26:49 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B74151A067D
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:26:49 +0000 (UTC)
X-FDA: 84085851738.22.68CE92C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 35ABA80008
	for <linux-mm@kvack.org>; Sat,  8 Nov 2025 02:26:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=StlgWGzx;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762568808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gLdsWaG4wrgTHPgqEQSOkUMDs2+UPqWHSnstrM4DLoc=;
	b=Vaq9+mitO8ZjJULahYe4NSdeuOfNyJc3xgcJrIqRm6bQk6aV4UMsh+JEFQF5FIIJhmmNP9
	cBS3wSKho65c7hV564ST45ySKFV0ItGq12LqKKJ9RTmqzz59BCCOI+2qA+ceVFlKDnH53y
	fxLcruVQHsvZRfm701p3hjoYNy/nJWw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=StlgWGzx;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762568808; a=rsa-sha256;
	cv=none;
	b=G79JupX7GoVrP3LN5ncRX2LfyLRJidZf8gGXLtks7U9Jwme6olOVKxd2HLUqEN2NwigZZq
	aDpQFeq9w9ozGs513l1heN2hDlhkj6brmMZXszApYgqSENLOxwy63gJfo07HtDiFuOQ8+d
	kD6seQqMM7ILfl0khtKyix+Olbwxyz4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 756656013D;
	Sat,  8 Nov 2025 02:26:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D19C5C4CEF8;
	Sat,  8 Nov 2025 02:26:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762568807;
	bh=oA3CoxR0bDnOkhkDCPr2By20i9HybBASnRQLHnaJ/FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=StlgWGzxh3Q5DpZyFtP8lWwkxECa64WL/fWIcFXzrQeNc/2uRF4+obZx3jrZsFvyh
	 LLOY56R7R8HgxNpmwzpdUgH6/l7Q+EUDlw8Au8pRms2qNGiMrN1oaCf4WP1uZRo7EP
	 COJpzSE/RpIBNE/+8EteQ9MreKrxxzF1jv1h7CcdIsLlBQ1lCiV+DdvXQdHXynzqGy
	 1ykg4kmeHKMDJYAveCMIl9mDaQAjpDyqhBuK3/Cx+6l1dcBSyntP27KUNm4ViDchCp
	 D/EqlxVk3EKWMPQO+swcxZMSI6reze83hzRx5Gub5WrEOc4XF09UDjhFVTm303Omnz
	 qoV/PyTp1I1Ww==
From: SeongJae Park <sj@kernel.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Michal Hocko <mhocko@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Meta kernel team <kernel-team@meta.com>
Subject: Re: [PATCH] mm: memcg: dump memcg protection info on oom or alloc failures
Date: Fri,  7 Nov 2025 18:26:38 -0800
Message-ID: <20251108022639.73734-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251107234041.3632644-1-shakeel.butt@linux.dev>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 35ABA80008
X-Stat-Signature: cdj7qqih5tf1xocok9s7ker4x9wmigpi
X-Rspam-User: 
X-HE-Tag: 1762568808-120228
X-HE-Meta: U2FsdGVkX1/e7l1+H9Y4n7u9FTiIkUXBtFUhbbKwtPPjIGBAG4Y8XTbf6ulWyCm4PnyZYVM1OzWQsu5mt4VOUNpLueaWuwW82PDvr1xut/3pZluuV5AMg8EQrJUZdy/N1LHXBGQKGpg27EdSOY+Q7E3W95JSqoWlPNhDA1BvMD4tEuIhw0weHkGhC8edc8tmSONalPZzUv3ItUwHhfwCKFCdEinKHxFEGGLowy1q7sqw4TCWwMSURfgY2jV3fnpyPAE70bHAPw5xo66DQGHc1NhHoeA0uf4jamJlgFaUQO3MNaPGXFctkof8zCBEg7+wQ2OLK4Fj3Wpo7bGiNlmVdQpC09/v0Ny/3sUY3NtUjreRqi40kjk34f2uZb3rXrluUtADDvFj1qtqcPlEkcvkT0neGoeuIgBXUxb7JvTSYWtH9i6lLhfnqZvAumT9RN0SmwzBWnAAHXQqr7exwuGlCoS/6o2p+KPZceFBujH9rXICc7DaYGABNX8J/UZyVC16FA4GPV3NkyMtDmAlW9nI+p/V+kgo78H/KH4Xs1UobXSYLNPESR9k0TkNMHqibiUqLY/3wdd7ifk7ZvRHze3Yv9Yle4crZP2hVQm+cmguHV/4qWlqtFTJrZoKJerXBMT2ISVqN76QchZKBvmanntyiVtRWi9rNv652/9f/kx6t08TH3mXkTRic4Pc79Q9XFYcFdtMFD6dGkDpyw4A31STzkdseV9lr2wnvXnqkC1jd829qkwOmEzmoKjri5vMcBs9L3oCjoXRqAKVPrDCu++jwPuLjNHSUmRca0ki6y9DovkfB9kvWOTaqOchTNS0++OlfiZ8GU623+P280g5G7hoDk/U7SEtoF1VF83WJar40aJrzbart669oVd0OcTZf4h1bZrYptnsAP+0+nsSRnE+ZRrncry6ixVE3dvV0dJjVSeoenYE9fnTh2DdRcn116Hb8dxPh4PGEZVMks9RvUp
 6KeDkDiU
 AfuxhjzFUCY6MpmjBBvDqNLN9YWT6afLhbBP6tAZ5h4DhXOCwUqKnPTpEFhdoGXXPrL1vc5sZ0gtwXmGNuiZ6nCqb2l846Up1XHEUBO0+1EsD3SF2yp+JEr2YL4x+FrDknU1Jbfjd+TJ+someu2WX36AtosTa70OPCmrVckT9LpDEJ6E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  7 Nov 2025 15:40:41 -0800 Shakeel Butt <shakeel.butt@linux.dev> wrote:

> Currently kernel dumps memory state on oom and allocation failures. One
> of the question usually raised on those dumps is why the kernel has not
> reclaimed the reclaimable memory instead of triggering oom. One
> potential reason is the usage of memory protection provided by memcg.
> So, let's also dump the memory protected by the memcg in such reports to
> ease the debugging.
> 
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
[...]
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index c34029e92bab..623446821b00 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -5636,3 +5636,16 @@ bool mem_cgroup_node_allowed(struct mem_cgroup *memcg, int nid)
>  {
>  	return memcg ? cpuset_node_allowed(memcg->css.cgroup, nid) : true;
>  }
> +
> +void mem_cgroup_show_protected_memory(struct mem_cgroup *memcg)
> +{
> +	if (mem_cgroup_disabled() || !cgroup_subsys_on_dfl(memory_cgrp_subsys))
> +		return;
> +
> +	if (!memcg)
> +		memcg = root_mem_cgroup;
> +
> +	pr_warn("Memory cgroup min protection %lukB -- low protection %lukB",
> +		K(atomic_long_read(&memcg->memory.children_min_usage)*PAGE_SIZE),
> +		K(atomic_long_read(&memcg->memory.children_low_usage)*PAGE_SIZE));
> +}

I didn't expect this function is showing the information by calling pr_warn().
To me, "show" feels like something for file operations, like memory_min_show().

What about s/show/dump/ on the name?  It makes it more consistent with the
subject of this patch, and other similar functions like dump_page() ?

No strong opinion.  The current name is also ok for me, but I'm just curious your thought.


Thanks,
SJ

[...]

