Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 869F1606A33C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:54:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kUjnB7jj
Received: by kanga.kvack.org (Postfix)
	id AC9E76B05B1; Tue, 10 Nov 2026 11:54:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7A206B05B2; Tue, 10 Nov 2026 11:54:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 990536B05B3; Tue, 10 Nov 2026 11:54:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7C8A16B05B1
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:54:12 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 250FDA878F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:54:12 +0000 (UTC)
X-FDA: 85419807144.27.7B156D8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 8918B80005
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:54:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUjnB7jj;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ex4dVJ9I9Q8lqhJNdjzHP1bMR0am48AWVaJF7+qsMjA=;
	b=buBa7ywZiCnMFeqNgonYGmGd68o4KrxV8YBxnEHLXcjdfBxtzHMgt55XRraritxB0T4YNr
	5J5p3xobQeVAdmeAJd/NpSVv5sXKxDE/Q1HvQyxcYdl0vH+75Hq+jnba8uXGc/r0blgDoH
	6fhgPcRi5iN3EpZsC2UUe3ek+1MLTXo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kUjnB7jj;
	spf=pass (imf02.hostedemail.com: domain of pratyush@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=pratyush@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329650;
	b=spt/756j9IQHVp7X/jtwwwzmKXaJDi9i2XAqLtD8bJRGCsMvuQbdXdKif5liCf6H6690ul
	W+WxA9F/r2zLDCmtX8OfbAG1v6+9M8WANC8md+eSIhbPSaVBN0/16tBlcIma4FxSY6+1zF
	H/43qNtcwMAp26GeMvyTT9rE0EsiUxY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F220461DB4;
	Tue, 10 Nov 2026 16:54:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 953741F0089F;
	Tue, 10 Nov 2026 16:54:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329649;
	bh=Ex4dVJ9I9Q8lqhJNdjzHP1bMR0am48AWVaJF7+qsMjA=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=kUjnB7jjWwbn6apvOgtDPvTzekBFurc2yWAt+G4hqRvI8O5lNsAhUcsIyDTfsh+Si
	 SeTF3N+b4eOamAS0Ibbv55mh92DVwaX96cf8VKOxWASg0HLYtUZDtqVANs7j9tRUP8
	 TdLmGIphHJhyp8LCoz8oSqLhi1QjBhg8jqNjDAmOy1kOkVNjq3Xkn2Psn99hvE9mvb
	 fnx1bzYQWtKg+xG5bi7ehexY1sbmWYYUIBOAzUFGoE2RFDDE75jnLYKjjzuedaWMup
	 nxzG8Nb7E5fD248tLjuX7ToqybB/EqltODzgwyJErS2Q5swvfHJrAkZur0+Ici9BMR
	 vLYdm4F5aVAUg==
From: Pratyush Yadav <pratyush@kernel.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,  Pratyush Yadav
 <pratyush@kernel.org>,  Alexander Graf <graf@amazon.com>,  Andrew Morton
 <akpm@linux-foundation.org>,  Chen Pei <cp0613@linux.alibaba.com>,  George
 Guo <guodongtai@kylinos.cn>,  Kexin Liu <liukexin@kylinos.cn>,  Sourabh
 Jain <sourabhjain@linux.ibm.com>,  kexec@lists.infradead.org,
  linux-kernel@vger.kernel.org,  linux-mm@kvack.org
Subject: Re: [PATCH v2 3/3] kho: fix bootmem sizing
In-Reply-To: <20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org> (Mike
	Rapoport's message of "Wed, 04 Nov 2026 18:50:11 +0200")
References: <20261104-kho-bootmem-sizing-v2-0-b0d1a834780f@kernel.org>
	<20261104-kho-bootmem-sizing-v2-3-b0d1a834780f@kernel.org>
Date: Tue, 10 Nov 2026 17:54:06 +0100
Message-ID: <2vxz33t8iq4x.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: uahiy9ub6tipr1e3nbekimu8hooqrys7
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: 8918B80005
X-HE-Tag: 1794329650-686013
X-HE-Meta: U2FsdGVkX1+nuAz1GfsFFsN51GAf5cM8ikGzxJj0LYMimc7A8znQBQj3E7eZGiT2Smw+KRQNJpq4xMkKRiLSxeX6voJG4mQv/LD5wVApmAsWRESBXEFiVTQJMnGhK0fk/l7gVBRUcv8JtdiMGXvn2lo2JNQ2nE1mwrvFsIAkN5/CfXo9Ug8fGXYzVnH2idHoxD295fbvZ5WcqqJUAkJtF3f29Tz9g67UvXLXq9qwrUljTi/+B5pm2Gkb+GWE33MLKvq0fJavRsd5Rb2RZv1PpXjFdsPJSNwZzBcK9TBnI0aNDh7LpSpOefDNmS4rsLQdVddgsfvkcoLZmUgNLMZyL76Blx3lkSQDAFWSNxEjfeUKL4P1oaXujfF+nkjKxezuFPpMk+Q1qjy8d8Xk7WEvryS2uyXbQ+kOn5RgPqHAlemKfhQVpbBTDuRnDMhz9EuolSPbjY+OL/cFhTEshAzfNUEv39AZUqJ6dJG2JS+GUlRVXIecd45hA3tGTKs0OC0ryrRFZ7Lr6iMj1bEVJro5gC39zo4hrQPVBgBGZUjDhcU+LYPbxKnxGH/OQAegiSjMdFY3LDakxvgXVX5Sf50XBMkFaedMz7wxJaERVrqZjZcJXDTMZk8IzhA3fxORZSLI3ogrtmkEl3Ku5ER7kCY/29Zgd0jRBbqNj3LpHx8GT0iSWm5jHVpysqikAaPVDVpsv1wT2YRxuoRkPHdat07Y/OOt+EWMvPAr8JFJsVM97nFBBQQtfuQI4jxsY58v3mkKL11/jKu+ap4r1BDmRIj+YVqC9PmQMYxnMBX0LCD6MzfSqNWwGkLNcKGgPR9CkbyMzqyw4Ci8Np36Jz+tGWc1NVQznfVaWHBWk6ZPFyeWIKi6MF87B/583SDMYeUE9JrItHOio8uUmdRJ2Ngma+eCLODSSKZXLMtQlgYRfiG5B9KS/FnYFR6+UJfvKjowDOtHnLFAF0mMiNut0muYlcs
 PEaSBh6f
 LVIaD3QYkffxQUCQ4A06Tdd1AQT3wLhDxXtKiGBbGeHaALnmOlP3UuU1RdLe41FmEh0dx9H4rKd+eywhpH6TSDzxDf1ORBZgunGpxupOn0EaTSOWDqBhCJNaczrk0xpF4H80Du+WdGgcnA0nLOSbIKLnFXQK2xse3LyfmmyLgOHx6mRzL/S75JS2jYTzZmvIq/OKxQ0wScLWGJQKYxOQW2Oory5zoK/BSg7BTRlWjhIsWRUB3B0BqupeAh7mjmoYh0mPn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 04 2026, Mike Rapoport (Microsoft) wrote:

> Bootmem areas are sized from overlapping views of the memory reserved in
> memblock:
>
> * the global area is sized from all reserved memory, including memory
>   allocated on specific nodes, so on NUMA systems everything allocated
>   on a node is accounted in both the global area and the area of that
>   node.
> * per-node sizes are calculated after the lowmem and the global areas
>   are reserved. With CONFIG_NUMA=n all memblock regions belong to node 0,
>   so the lowmem and the global areas are accounted in the size of node 0
>   area and scaled once again.
>
> As a result, bootmem is about twice bigger than it should be on NUMA
> systems and about four times bigger with CONFIG_NUMA=n. On small systems
> reservation of the bootmem may fail and then KHO gets disabled.
>
> Make the areas cover separate parts of the reserved memory: the lowmem
> area covers allocations below ARCH_LOW_ADDRESS_LIMIT, per-node areas
> cover allocations above it on each node and the global area covers
> allocations that are not bound to any node. Calculate all sizes before
> reserving any of the areas.
>
> With CONFIG_NUMA=n the global area becomes empty and it is not reserved.
>
> If ARCH_LOW_ADDRESS_LIMIT covers all memory, as may happen on arm64, any
> area can serve lowmem allocations, so don't reserve the lowmem area.
>
> Bootmem sizes in MiB in x86 QEMU VMs, before -> after:
>
>                      CONFIG_NUMA=y     CONFIG_NUMA=n
>   1G,  1 node         176 ->   92       320 ->   80
>   4G,  1 node         508 ->  332      1264 ->  316
>   16G, 2 nodes       1268 ->  704      2944 ->  736
>   32G, 4 nodes       2296 -> 1224      5196 -> 1300
>   64G, 4 nodes       4344 -> 2248      9664 -> 2420
>
> Fixes: 3dc92c311498 ("kexec: add Kexec HandOver (KHO) generation helpers")
> Reported-by: Kexin Liu <liukexin@kylinos.cn>
> Reported-by: George Guo <guodongtai@kylinos.cn>
> Closes: https://lore.kernel.org/all/20260904025101.9959-1-dongtai.guo@linux.dev
> Reported-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> Closes: https://lore.kernel.org/all/20260922131217.698809-1-sourabhjain@linux.ibm.com
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Reviewed-by: Pratyush Yadav <pratyush@kernel.org>

[...]

-- 
Regards,
Pratyush Yadav

