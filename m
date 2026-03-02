Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BFADEB363D
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 22:21:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEAA56B0137; Mon,  2 Mar 2026 17:21:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C6EAA6B0138; Mon,  2 Mar 2026 17:21:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B71396B0139; Mon,  2 Mar 2026 17:21:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A83166B0137
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 17:21:11 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70434140347
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:21:11 +0000 (UTC)
X-FDA: 84502544742.01.8808C36
Received: from out-186.mta1.migadu.com (out-186.mta1.migadu.com [95.215.58.186])
	by imf18.hostedemail.com (Postfix) with ESMTP id 853961C0010
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 22:21:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5qBYBhf;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772490069;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kxrIqC4lTYaQ10ka6NqFm5OmD9rPDMHzGSGdgraOMEg=;
	b=mW2/VaURp5whNQ+xyk1b11wKkH0LSzRJRvT3hitUQ9En5C5s2tCHSegLEAp6k/K+DZYXle
	Mj779fwboDEgLRaYJz6+m3LY7AHFdhbrnhKioi55AmEXnqb2tE2Mfex2RS55oSjB3nC0+Q
	1gB7AW1hkgYfpeb9DMSJ8s3hM56jjac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772490069; a=rsa-sha256;
	cv=none;
	b=oPzXJj0WICYSbTo+HRd13lnF2wTbopekb3dQJgqTSKrQTAVQ2elVWFCXgrb1C5igTB38Mw
	meTwoNzS2fWrUle49YBwwDR2pr0OmI6ClS5Z2f/rztPlmrgKcCPUjlQ4xyqHvYYjR9TX4o
	w6WS/DBI369MSBRN6czJ81iHQLzAXoc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=I5qBYBhf;
	spf=pass (imf18.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 2 Mar 2026 14:20:32 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772490067;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kxrIqC4lTYaQ10ka6NqFm5OmD9rPDMHzGSGdgraOMEg=;
	b=I5qBYBhfBL7RM+n9tcitpC63AArsIB0Echd/QGCuxpghhgcyLn1x1g524QDKNs9PGJjFc5
	mzS9QY7M33beBsSO00PAS0Jqf6y3ftwMbTuC3N1bAR3SCC4h2C3+fu1e/dMB+2CyU8yss6
	HB0nClNoAyr4j8xbicwiok+mySUNHhI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] mm: memcg: separate slab stat accounting from objcg
 charge cache
Message-ID: <aaYNDbFZ2AHM7gKt@linux.dev>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-6-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260302195305.620713-6-hannes@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: f8641r9ttbg9ynumtx1jtkxi51t6ifur
X-Rspamd-Queue-Id: 853961C0010
X-Rspamd-Server: rspam03
X-HE-Tag: 1772490069-319828
X-HE-Meta: U2FsdGVkX1/W52/31hSa4eMwngV6WY2c8vKnKKShQN5/cWr/OKqhUCXk9hgXrdW8dRyRf/UiYy6nOE1ASQ2JtCVAF0FzC9D6bocMJlUkpJxfFzttdefwjtP6Lgkb1qdJdqSr9q/6mqGo33Qog7oksjhhOC/Mf/vzJFzihPwaszw8nCJW7Ymm5L3Ydv3x3U0dBnZlNhJ89j0AFuYjGMvTFNPli8a/NnB9Dz86W5cUXFgOWiU3VuxDv0+hTXVhk3+84RglZXMqN7nt+chxRvqZ9pyJPyyK8YVP7buAAfFUng+mgpfX5K4Lo4xuMLZnczgwISIhEsAszgzl531BArkvnGnxYWrvbAyqpDaQcf9I9UKjT8KxMKlzWQ4hqp+1uTi3F78CyfZzyx+jRNxQ1L4SKjBM6gF9TbRLNmbbg0fniZFVlg066jhJYDhR+DfZQ1GSi2uJjJob9qPNUvbPDfahFzRNEgLojLDx8wXJxq+bvqmN1AnZEzf2Ok4ZGqwJVbj1uzBbD+nNu3UfqyCrIi5XodQrZDzJwr6mwBIrtrf1WIDMfTRXe+qF2yZEVdkRnUYf2eS01bH6DTYeG+dSKLpktUv7En86WQrhz4rGchL5cvKL0xGBExDafBr7xaIZcLsUXyC8CL5LlKG8rgBZcboo3QwlDzWGmMZaLR/3lSCqIwyPrXo/7TQlyKoVFkwE+0dTecqDU/byvn2ZolHr/fjxIuRTTP881sNk15J8uzqnz6g2RkdN63MhRg0W+1ZOpOdp2n88Jto9bjYvU9Rx2g7qUuFuz5RH4pVAcS+H/2ex/ny/YR9+wBvngLW3jbTBvApDgsEVa7D2Tszj0tg6C2L9XqMYGBaoQFqLLgsqoP9QIHzcimI4kKwz7qaCv4K4geUgRSxkwAx6PNz4Abs4cmjHNP3bGmzO/SNgnJtR9kGs0bEaohUlG2UiQXBylcbdBsu1ParcEN9065iSha1b+hk
 RyyaWcDU
 KZZEFOoBlseTjYoGiOAo+o4duoEProtEGCC2vxtcGjuKkgHgPSwcyl+60jVOUTKnFnFXf82bcNc86ujQocUl2DgOT4duY22TWbdrt6njin5ztOXDS/KuAbUHhW8BlEPewI+AdkGvGaR9NIskNFIlDDT+FRxhvsFBO33yjt6IvfwB3kZzgXrDbjcf3vmsdOf+TXTU58PoCestEEW9u+/eZd3OloKizx/qLP+R5MmcOUhimEpESazFaFdhsfax0yI6L8IFj4gr/Hxrvmko=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 02, 2026 at 02:50:18PM -0500, Johannes Weiner wrote:
> Cgroup slab metrics are cached per-cpu the same way as the sub-page
> charge cache. However, the intertwined code to manage those dependent
> caches right now is quite difficult to follow.
> 
> Specifically, cached slab stat updates occur in consume() if there was
> enough charge cache to satisfy the new object. If that fails, whole
> pages are reserved, and slab stats are updated when the remainder of
> those pages, after subtracting the size of the new slab object, are
> put into the charge cache. This already juggles a delicate mix of the
> object size, the page charge size, and the remainder to put into the
> byte cache. Doing slab accounting in this path as well is fragile, and
> has recently caused a bug where the input parameters between the two
> caches were mixed up.
> 
> Refactor the consume() and refill() paths into unlocked and locked
> variants that only do charge caching. Then let the slab path manage
> its own lock section and open-code charging and accounting.
> 
> This makes the slab stat cache subordinate to the charge cache:
> __refill_obj_stock() is called first to prepare it;
> __account_obj_stock() follows to hitch a ride.
> 
> This results in a minor behavioral change: previously, a mismatching
> percpu stock would always be drained for the purpose of setting up
> slab account caching, even if there was no byte remainder to put into
> the charge cache. Now, the stock is left alone, and slab accounting
> takes the uncached path if there is a mismatch. This is exceedingly
> rare, and it was probably never worth draining the whole stock just to
> cache the slab stat update.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks, this looks much better.

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

