Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EADF8FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 05:53:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 20EC86B0005; Mon, 27 Apr 2026 01:53:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1E7046B0092; Mon, 27 Apr 2026 01:53:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FCD96B0095; Mon, 27 Apr 2026 01:53:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F37C16B0005
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 01:53:50 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A0DD4C25E4
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:53:50 +0000 (UTC)
X-FDA: 84703269420.24.DDC5A60
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 1349A40007
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 05:53:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uagwAJjs;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777269229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3nG7c+WrFDmSj9A9bY6ptLnaECfAGeA7gxCCYorz7/g=;
	b=lKOzo6onVN2g7yx3VsKKkCLtWjl6aynWbjSoC7yI2flLlRW8Xp8VFzT9j87nsZlOK0my3N
	rtz9qcUDf2AaD8h5NGfA4ZvtOyVyxNIFqftFdOBpBz8f1KsvFhQAeMH3GDYQiDAOmwqRx/
	HwEviVLDl6qFIgSE7YR8oqRN/brQZHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777269229; a=rsa-sha256;
	cv=none;
	b=SUxXuMZ02AWz0TJtU2td0aQJLu0O/ySZL3sQ7aFvKmMn0sDxUwRG6w22AlI14g14yOVnIz
	240bVMJqyGc5D0Pg1pf6x+AqPCUyRMX3xhNGbh2GEQt9i7sqo3ppihmUPFGIie28c984bY
	cUohliKjU52rwUit93jTdZSbLG4X2fc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=uagwAJjs;
	spf=pass (imf17.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FCAA60145;
	Mon, 27 Apr 2026 05:53:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75A64C19425;
	Mon, 27 Apr 2026 05:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777269228;
	bh=Uo0/I2ScI3i97jP0pB48LbPF/5TITvRJVUrClnaAOA8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uagwAJjs6FewmJFpb8ZPXeXkzE6KhbNsUEW88kIfUfRlwLZVE+907ioJu0st0CyhA
	 0Fg9093xkuP0Z3Aq+QcBwy+IkRV7o+Zqt00IjO9FvXwOHoYI/t2C4KxFSsQ0XctsaE
	 +IzAkTu7TEsTMYkRLHmdp9PZegtIC6BEzAYYuYEMPW0GGSg4UC9MmkHspsuGXLb4Wf
	 YN2x5oWsGC+H70NtiplmoxvWVCghUIANl7UoAzSa+/ufprOUV7N2Oq0wxEoJdkDA6r
	 ubaOykut8cam3amMV+nVEKXx/EEK0pd88yupXfFGjvNj6M+X8TOBGqPdneWOPSiTWy
	 FvKqnvvDUA/IA==
Date: Mon, 27 Apr 2026 14:53:45 +0900
From: "Harry Yoo (Oracle)" <harry@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>
Cc: Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH mm-hotfixes 1/2] mm/page_alloc: return NULL early from
 alloc_frozen_pages_nolock() in NMI on UP
Message-ID: <ae756RnFbxIf-4Tk@desktop.tail10959e.ts.net>
References: <20260427054736.566559-1-harry@kernel.org>
 <20260427054736.566559-2-harry@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260427054736.566559-2-harry@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1349A40007
X-Stat-Signature: rn94fachmr9px6y8r1o7e9twcqsqh7mk
X-Rspam-User: 
X-HE-Tag: 1777269228-160403
X-HE-Meta: U2FsdGVkX19+EdUrHDaA72+9PUNWN5SEHm6DZOizT44vTxs6ZcEuTKs6RQIIydBgvip+yGGxMaWg90H7Mp5hfxsboYEgilWIK/eLVWwar9/Ti7ij96pcVXXscGoIKRodxwnPMobjBfXXKtxAbfPefWu8OyR4kuyYJQp63W5qdRxWHvj2vS5qiXjhjmRIcgs8FSST9CbFd5FjrPxMbYBZlkoUfhcgZe1Owah0sPEJreyng7zOETBWYUk8YCgneRXfvCktNH6CcPNeN96ZxvGcPziCqPJFYrF6s5bywXpf2q7iCwMVGm3SQgL9eQT2dgRSX4RMAXQ92TZFw3rTBlWrL5tcxhR0XfTkwHDO4+8sUmmoxYRkJevv+i4h11uJYQK+uZkOmMVTFGUkTKcLORopQvcZDNM023utuyP6I42l8xx3Z6ZOLljKzXiHay2By+Pg2TWtJWncmZ/qUlyrw5kYjMTQPMK0ow6zjfaRw0Bj5uy/AvsVTObC7Yba8iSL30p+RZ7B7qyGKZ03OWTVS9nt3XKpiXpjMIhIihJ8qdMTpv/FAqZduRPqQuVz7JHNrF9sTOuxWJ9deeVtRyAxDVXpCMnteU5y7Aq52ZLEwPg1YHhBoTeCk/dUHNV0nvEGqPdFn+sjfYjpsq3knb22samktfuZ6MyeLpDllf0yw+UkNce/D2nITmRaVTQSIQMBUI1pMJGAYa6Esw5On4aTh7PJOFmLsXodz1S+C+nGNvePwGlb7CqmfyViNmlPsTYXX0cpBg6EoBQiaiO2reYzTCcI4wICc7CBN92OtRTm3Xd+YZWp17f3SogqESMmmrp457Q2Rn+Cyf/Dsi5+ctQOIf5cPqWzyTbZ4gggwDNTwZ3CQ1IZ3c2B0OVp5C2PyqqtQIyidFkCyZ6m5IKIlM5Fty+uVtO/1qj2zLy4Oho73KI4CSXWcj1v7CBmOXP0E0q5/oUpKuFUTKw7H387z6APJuS
 JTiIxqXr
 DgRnk9MaUYAtz1DNlqlKwtHj1G9ZJk7vY6JRIsUEYHDeByUpFv6PKjAwQfW4ZAJhZD7GF4cuLkP70UojxwA4lFh6yp5cLzByH6r1ZrejbmabfRNtRNUmiSQh4AVr1IXrLO3G328NXhgkB6c9BRZc2jojGARFKcb6jLvuEjjydpnQH/PRTLi8h2U8D40QMnC0Lb4dNm7OegDw7GTw1+qyGEofOytlZ4WPWYxWk3HX6gK/Tet7ubTbW2gvkbjStILXd1KyT69Vi8Kx8XQNjwo0FuJi6cX26PGloMdU4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Apologies, I meant to run git sendmail --dry-run but messed it up
and sent V1 twice :/ (w/o cover letter). To avoid confusion, I will
send V2 with the cover letter. (Also I realize that I didn't add Cc:
stable on each patch, so will address that as well.)

On Mon, Apr 27, 2026 at 02:47:34PM +0900, Harry Yoo (Oracle) wrote:
> On UP kernels (!CONFIG_SMP), spin_trylock() is a no-op that
> unconditionally succeeds even when the lock is already held. As a
> result, alloc_frozen_pages_nolock() called from NMI context can
> re-enter rmqueue() and acquire the zone lock that the interrupted
> context is already holding, corrupting the freelists.
> 
> With CONFIG_DEBUG_SPINLOCK on UP, the following BUG is triggered with
> the slub_kunit test module:
> 
>   BUG: spinlock trylock failure on UP on CPU#0, kunit_try_catch/243
>   [...]
>   Call Trace:
>    <NMI>
>    dump_stack_lvl+0x3f/0x60
>    do_raw_spin_trylock+0x41/0x50
>    _raw_spin_trylock+0x24/0x50
>    rmqueue.isra.0+0x2a9/0xa70
>    get_page_from_freelist+0xeb/0x450
>    alloc_frozen_pages_nolock_noprof+0x111/0x1e0
>    allocate_slab+0x42a/0x500
>    ___slab_alloc+0xa7/0x4c0
>    kmalloc_nolock_noprof+0x164/0x310
>    [...]
>    </NMI>
> 
> Fix this by returning NULL early when invoked from NMI on a UP kernel.
> 
> Link: https://lore.kernel.org/linux-mm/ad_cqe51pvr1WaDg@hyeyoo
> Fixes: d7242af86434 ("mm: Introduce alloc_frozen_pages_nolock()")
> Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
> ---
>  mm/page_alloc.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 71859993dd54..23c7298d3be2 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7737,6 +7737,11 @@ struct page *alloc_frozen_pages_nolock_noprof(gfp_t gfp_flags, int nid, unsigned
>  	 */
>  	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
>  		return NULL;
> +
> +	/* On UP, spin_trylock() always succeeds even when it is locked */
> +	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
> +		return NULL;
> +
>  	if (!pcp_allowed_order(order))
>  		return NULL;
>  
> -- 
> 2.43.0
> 

-- 
Cheers,
Harry / Hyeonggon

