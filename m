Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 158AFC55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 14:13:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 224026B00A0; Thu, 30 Jul 2026 10:13:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FB116B00A1; Thu, 30 Jul 2026 10:13:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0ED686B00AF; Thu, 30 Jul 2026 10:13:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E64BE6B00A0
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 10:13:33 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8ACDC1C0158
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:13:33 +0000 (UTC)
X-FDA: 85045635906.28.CC89362
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf29.hostedemail.com (Postfix) with ESMTP id 6E8C912000D
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 14:13:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dKNuJefd;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785420811;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QLkNt2H80eZrmEFB7rGaX5sD5ucgaW5cZGvSCwvv5/E=;
	b=FtaTYRxb3Hktf6iiHQ14NopLenhKG7Z1vpUnLjH5dc7g9v0SDGeCJ+D2gpOlIpCn+zUJHz
	U9EethDV4nuqOYOthNueVLUYFXfhHMBAUDtHNkjYg8WX8PMswzmQP8Q49F3mTQAn7wvHKb
	zJYNnpMvvtsN6YOb+C8z6EzBOEETIFs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785420811;
	b=xknWcBYPUUx9hx0E1HKRkWKnfQilE2J7BIBVkS9K3qIkvlt6iGoa3JuF3MF5EqYzJu0vBc
	biDAjusAF5QPbnfp3hfKHw8KUF2TqdgLX3I7mPH6WA0uhy0Ih2JFLlmx9BeC5f+06qfpUW
	M9esF9c1fpz1ErzVaYC9YH6X+RZ9sP0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=dKNuJefd;
	spf=pass (imf29.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.219.47 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-90004d2f7b7so22593276d6.1
        for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1785420810; x=1786025610; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QLkNt2H80eZrmEFB7rGaX5sD5ucgaW5cZGvSCwvv5/E=;
        b=dKNuJefdODjE2fnh8M7YqvJp9k7kmzoXXYNd8IurG1gWo7PNwxSz8PWDiSr2uvklAw
         /K+cpm+KocCH2LpW+jkO45dyp+hL6N7gXWKSzGaX7Hz8Bx1Z1p/v2ZEAvdwijz/NgvcF
         q2ibw31+1fmji79qGxe/bEUrwYrqMibckTJkI9U7EIHu+udRvC0M6e2LrCjtj9Z5NX0N
         XR6waVqfcXJsvIX+s0cXel3CqmBcr/9vrzd9RkrXnJRSRcZP9wYxeowxzmCfLk+sdi8A
         onLNq/CbFP/NNRGIJ+F7Bzm7oVy3aYVhST52o310qJtxdahttoNE0ZfBgoYP00cUndYn
         Z1og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785420810; x=1786025610;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QLkNt2H80eZrmEFB7rGaX5sD5ucgaW5cZGvSCwvv5/E=;
        b=EFYsXFPGWOnY6Ozg+bsA/eVLO/jee0BxukZACGGuo8PLK+bCmweQ6evSZc5JTdPFnD
         JiaPMovUzT0JdVXuxzDIgk9kYTfdMA268xqh/v2n3rAw6ESNbZVaB+0Z1mTr8x7puEDL
         y6oNVXOA6rB1C3mUQ2TPCh20DOYXHQLW4kO4Rd5BRUeFUCvYYopzY2SpXf8YUXbjm0R9
         j8EEvuOI5KQemJLE/7aj2c6p8zL6BCotN8TKqCn838cVfGWtYyiHTwDT2FHpUTID9EK/
         sCdxMWlk3NGwyla9Eui/IXJez+iL1Lkyr6BZI+vFqj5WOrV3NLZFbnKtssYSj1PuZWc0
         5MrA==
X-Forwarded-Encrypted: i=1; AHgh+RoaT7hgvIaLUNffNY5cKh1+17aEyMQ/PEbNfHh1xVTjf+jnVhK7I7BQiA9R00PuYgc/sesbsisQAA==@kvack.org
X-Gm-Message-State: AOJu0YwFaZMB79rxDPg7zc+rW0ADlWxXojJM9yBa+OnmXtdxnD/BzQfi
	AGIuYqV8wZDB6YfC9PtBJ+NlBsy6WUsPWa2XD75gkG2IcLMv30fYMsOS+f1dPI/jz20=
X-Gm-Gg: AR+sD11vLt0W3nlG5VGGkvwFq+5HCP3WKsEGsxDZggJpb+UEYnCnq6A92ReqTD4hJqx
	TxEkRUd4ON780PCGBHWuNPQkF4ETRuixpZ7dDXIUmfP2of6XY4y18mnBWopvQZbpb45lAQ3arZ9
	ggyIfhg94a8q6ykme3CK+kd25b0wWaSG5nCvNTCZ/AtldIFnoZzFmNQOtxfEcMtgZg2fRSCoWrR
	ZNl8sMtzMnDYgEpJqrHf1OtE3qpDyh7+4Fm0me5WEQp4Zv8KUxgOaf5EhHmSk+BgqjbAm3LbnmE
	P+Dh5fHjtXAx8cgmo2JvYFmmAYhAT2glHB2hn7tfh0Fu2Uuu3keo+o7xI3JWhO6wZqlzCfbUklc
	Ud+e9kPoSAaF0gMOGvtXreDOKbvsVQlAoCkvxx5hnwp7YYB5PxZ5IoclTTw8mv6phyfPeilDXGD
	TA/amuNB/YqGVkJoZae8YvIJCFiN2HGgvorg0N+UfcXsSE0/acAd/31bDBQ+Q=
X-Received: by 2002:a05:6214:5a0c:b0:8ee:39bc:8fb4 with SMTP id 6a1803df08f44-908347a8e44mr25915246d6.33.1785420810359;
        Thu, 30 Jul 2026 07:13:30 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-908323eb758sm18842216d6.28.2026.07.30.07.13.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2026 07:13:29 -0700 (PDT)
Date: Thu, 30 Jul 2026 10:13:25 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	William Kucharski <william.kucharski@oracle.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH RFC] xarray: honor XA_FLAGS_ACCOUNT in xas_split_alloc()
Message-ID: <amtcBZ-_QVRgCd6b@cmpxchg.org>
References: <20260727-add-gfp_account-to-xas_split_alloc-v1-1-9fae6bf64838@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-add-gfp_account-to-xas_split_alloc-v1-1-9fae6bf64838@nvidia.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6E8C912000D
X-Stat-Signature: x5w7ejoyd5fa8epxmcb9jyhtgifr94z8
X-Rspam-User: 
X-HE-Tag: 1785420811-392288
X-HE-Meta: U2FsdGVkX19mTdCp8abDFopU8or2nj8ObtaL4min6F7yXydQX4Z4ySZmpZYU5ShQZkUyrX31vCSOUPoc+Rf5yDhjT5k3whKNbH8tQmaDRdT/Fdss4pfyk2LcHG1LZuYSBZ/kmoUEhjn4DYv5+zcNXejF2/13jyAeEeZT6hmxCr98ri9gsSUL9I4R002anMbV+8tvub3vBYP59jD/1rzLVkvSy+W/DkMlBzPOhbRV7qdQJqLdeVueWrG8HwLnP20tSSu/IXuDoznFzA8VXYdtqwl1MGNSu4wVgUfl6NtrPdGGzdiezLSRyKKyVVzRP2597iP950BExUf51ljcWwyttIETXVS6NjStWb00XDgmYWJndVsEL2Jf2oRVLsjAupSw8spS4OQUzO8cVXi8l35arBjpEZnrxw6ARoji3z4fBlLWMgoK52NcdpAjyaLj8cC8PrlGDTF8R6v62E9zAyX6HYw55OcC2pJI7cyZpYWAatwlp0daxRZ2fVSkywT+12EkunyQCwBVUfiscdRTYXk10JoUx7VRJscTG38deDf4X47V0+EfszEf2dMDSFctL+0TIKYbIqtoFhoWhz40V0Mtju/0dnQymPZBtMjvMePShIYBWo2F46DyHtyYNLoLFbd/iMJP0vV6WC2b6parG5GuacnCxj2VObbu+lmDJXSe5GGYZDZ6oAfV00RHbIiwPBPA3nLEJTYLeLldcBtsDlt41VmWIEWeBazCwbeG8pNkGFD7eR7bdMqoa+1xeaymkMNqosw5DiO6IDxI32jX0EGSEebqhcKN8ur9zNwtIebSwzdlxpQ1KuLE8v3mWGrwnJZjiNmVqEE2fzDRPwp7zSPKBIhr3eO6sB23N3o8wmWbhT30DtxD1mKPJHKf0R/pvydhwoGheoD/yj/ROrJIlG+OqSwSX8gtxLDexGN1bKDVWW2aeR1qh7uFlpf1K+kpv3wFTSJ8rY8eD9Vc5XlofQx
 HSzKdsb+
 LW6rYh2ciVI8pv0pVi0ELQvaFbPVNFGNqCeZkLcpVU/QXTes8imcN0y7GEA+Qil+ut9Buj+C6pOX6N7D3r95pGhAVQ2FlSsMt5bOB0HZEyCDJvjndme3+b9uOrUfO0b1Z6nFPgw3F08sI+DclOdeOVMuE7ZtxRequCXAhdlVae0es15QLNaF/PtU6NcjOoh5MTCpSUs/SKrJkldhuJ6f+KzGC3nu0+z+lB26WTMjVrRvZy8hf7FgnpBNVpoJJoJVEP58HOII6G5rHwvZVKnnUx88fncTqzmoK4yBto4x2B+2L2Xik5fKxhjr2r2Lg30UFmids5Mo9luTkLHdJxbV3fR7S9HykCKpPDgDxZ/OJPTkhxQ/MOYHQ13zxJyJ6l8nVvZywv/XTfqgdohrV+FqNofmPE8yaDyIckMxEVb35z1ICFXIHLryn0VUmdk2+M87YhWO1yvy8KleMhpf3z3jOCNQMSO1Jwzo9iFcS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Zi,

On Mon, Jul 27, 2026 at 09:51:40PM -0400, Zi Yan wrote:
> XArray operations that allocate xa_nodes, such as xas_nomem() and
> xas_alloc(), add __GFP_ACCOUNT when the array has XA_FLAGS_ACCOUNT set.
> This charges the allocated memory and avoids the workingset convergence
> issue described by commit 7b785645e8f13 ("mm: fix page cache convergence
> regression").
> 
> xas_split_alloc() does not have that flag. Add it when necessary.
> 
> Fixes: 6b24ca4a1a8d4 ("mm: Use multi-index entries in the page cache")
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
> Hi Johannes,
> 
> IIUC, __GFP_ACCOUNT is needed for xarray node allocation accounting when
> XA_FLAGS_ACCOUNT is set. Commit 7b785645e8f13 ("mm: fix page cache
> convergence regression") fixed a workingset regression with it.
> xas_split_alloc() does not have it, so I imagine xa_node allocated during
> folio split would cause a similar issue. I would like to get your
> opinion on this.

Yes, you're right!

As we had discussed on the THP cabal call, we should use the memcg
context of the folio, as that could be different from the callers'
depending on who's doing the splitting. I.e.

	memcg = get_mem_cgroup_from_folio(x);
	old_memcg = set_active_memcg(memcg);

	xas_split_alloc() / xas_try_split()

	set_active_memcg(old_memcg);
	mem_cgroup_put(memcg);

There is __folio_split() -> xas_split_alloc(). But there is also
__folio_split() -> __folio_freeze_and_split_unmapped() ->
__split_unmapped_folio() -> xas_try_split() -> XA_FLAGS_ACCOUNT ->
__GFP_ACCOUNT. So it would make sense to me to set up the memcg
context in __folio_split() already.

