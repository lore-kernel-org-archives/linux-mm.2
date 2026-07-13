Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73EFBC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 06:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 501BA6B008A; Mon, 13 Jul 2026 02:57:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48B846B008C; Mon, 13 Jul 2026 02:57:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32F026B0092; Mon, 13 Jul 2026 02:57:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0C3BC6B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 02:57:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9A7CF16A0AB
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:57:04 +0000 (UTC)
X-FDA: 84982846368.09.469D2EB
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf24.hostedemail.com (Postfix) with ESMTP id 6F37C180004
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 06:57:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vMUGp8iB;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783925822;
	b=2Y4HMeYLB0fsXwh5pqRD4E4k6p2rLwyg3SkffHS0P3sig5gZl1WfxhbJ3jrMLqE5yCJsl+
	A1o3AMRPHMx4jtXImfYxz+uaEgWmCwT8h4jEbtIyygrcWpuNIbWNvvk2Lam8mAelBneans
	9Tn1hVfI58i3zxRM187t24eqTCVrfDg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vMUGp8iB;
	spf=pass (imf24.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783925822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rQAHpQDnzihtw7jcUMgYCPB2YUVD98f2lEQKq6RVkg0=;
	b=aj8oarHwatjXUYeZ8mCsgdPM+3tU9TvQcpcBNA9EaEMVml8AIb3EWreDHtofV4cz/nRYg8
	yF3poFNI+4Y1ftbATF46bXentTskT4///W+DOEOMufjNR0ZSJuPipsKsb+QpZ6Z3+FVmJO
	z0O/XJMcWucyYkQUbqdsqL9qwPIMNoU=
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783925817;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rQAHpQDnzihtw7jcUMgYCPB2YUVD98f2lEQKq6RVkg0=;
	b=vMUGp8iBd1hqNeUPKxjP4p0bJFLxsPJZdFXYfyNfrZEFB8SOrt0nsGk1PmHgAdCt7na0d3
	WAOdaqiOJcYxuaKTkqzor0ti+U7UHlHUBarAj40wN3K7o83Iv5finEphcMq7v8m7SFNY+C
	t1J0uv9KOP7rJQiciUwn73tu3PMzjKA=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v6 2/2] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260713-mark-after-vmemmap-populate-v6-2-b945ceba29d4@iscas.ac.cn>
Date: Mon, 13 Jul 2026 14:56:20 +0800
Cc: Alexandre Ghiti <alex@ghiti.fr>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>,
 Paul Walmsley <pjw@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-riscv@lists.infradead.org
Content-Transfer-Encoding: 7bit
Message-Id: <E058B2BD-768A-4949-B5F3-7CBAC1347410@linux.dev>
References: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
 <20260713-mark-after-vmemmap-populate-v6-2-b945ceba29d4@iscas.ac.cn>
To: Vivian Wang <wangruikang@iscas.ac.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6F37C180004
X-Stat-Signature: 147iyz1r8bicwgmcur49ediu3izach68
X-HE-Tag: 1783925821-175309
X-HE-Meta: U2FsdGVkX1+w7pOAm6RJl+msccAtKsd8JJAbcSERtp1poZlceZ4inqoleMQqHEGMwtvtTJ1qHZW3u/jeyABV2IRvaQlPVOJdFzZBiPFzIxQFdHcjW8RVD8VAfTtVis6/+bSezAUcq3XWkBQXg3ZYv4fS3BxeumvzwwMihLxqlFAeRtgnbdu0k8s2WyNpNn1lfDrIPm71VQAND/oPlLttmBzYALw8bj4RspLnzw60Qk5zxgIDOcAB08aveI6nT7WFQZJ2Vh/xvcaqZCOPdj1fGOqGQ1Z4lbmM3LQGjGW/9KLkBtiypX5dYiYMUsTMR5gVkbVH/1pzrJodilpAGa3WluHvuUslmolJFmBH0RR5wYgfcKaQ0hJmB87uUGmdsYVlqnJW+hcypmIaJMKbHm6cA5R4datgX4XmHVs+iflLEk3gfvKEX9R24GbMbTzcRauhMEv29hl/WloS4AKG/YA02pAJybtd3ZjPQQKBYO1+1vxXDKB4VgLmI4gt+lih8HT/JJUc4+tBGQOPlW7p9XiZTNgCrhYPTTiql00xkLEIXc/LOcttiHxCphEodsBEhNJnbwPL/Lz3bFvJ2HAkM8cC5dtdXEzFx1YKFEXtfzGG9jwdcUbK5mxBgm1w6uByWe7s8ik3jJURvjfuD6wqZXvDF+hTifu/lfURn6yB/2tvjfB/SG0e8Ty7JE4WcjE3GPVsaT6X+L7bSP6oerbxTQvrDnJmrJ0AaQaB+7HcwL1M/JPPXXnaU0+RKD6wYdHOC3HQII655MtPeE1RN6fdgZWEBelh4zA0UaOil8hD/vTZ1/N+P19HZ9np9MD8IJ4Mv5/hP+eaYmwuRVe0UuV4224D3htEfEs3LU3C0iU32YdLij9w14BHahQyUjDoyS+mWaBi5gTq5AAv6NI66xtmWnDMAm7InpVkv8CrVi6GiKqgqPVSnvg9QRRzAyP3HJVQ5YowkCdoo14bRVC9RAWZbXj
 byxxWeaQ
 G0LhMDS1JToCU19eoKnSci7ftAoPQ22E5bibt4FnGdSheT7itufN3reCPUlKRvGaIt7rZC/zBsygaC+XA2oNpayY8qawOBEBxIcP8ebLIAoMVzWPLN9lTlFdMC/4zAfVpCvo6SA6zfofdRL0sESibzvBxuY7cxVBf4B7t/tpI+o6NqZNo1sySrWy+wA+tGgbP4g03vDGL11L6QoQKl6HDFfLM4ZzK3DViMBQTVREjDYL9q80wDC3qPUgq8Ml4YcDcjz9ifIrW2Rtyw902EdKB0YI1SrpRvl3nTmlS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 13, 2026, at 14:15, Vivian Wang <wangruikang@iscas.ac.cn> wrote:
> 
> section_activate() does not flush TLB after populating new vmemmap
> pages. On most architectures, this is okay. However it is a problem on
> RISC-V since there the TLB caching non-present entries is permitted,
> which causes spurious faults on some hardwares.
> 
> This seems to be most easily reproduced with DEBUG_VM=y and
> PAGE_POISONING=y, which causes these newly mapped struct pages to be
> poisoned i.e. written to immediately after mapping.
> 
> Extend the RISC-V flush_cache_vmap() to also handle the vmemmap range,
> and call it after hotplugging vmemmap, which gets the possible spurious
> fault handled in the exception handler.
> 
> At least for now, the only other architecture with both
> SPARSEMEM_VMEMMAP and flush_cache_vmap() is PowerPC, which has a similar
> problem with newly valid PTEs. But there flush_cache_vmap() is just a

PowerPC is actually unaffected here since it achieves the desired effect
via vmemmap_set_pmd. However, your patch will pave the way for a great
cleanup to remove PowerPC's architectural vmemmap_set_pmd, given that it
already relies on flush_cache_vmap() for the required barrier operations.

> ptesync. So it should be safe to do this for generic code while having
> minimal performance impact.

After the cleanup for the PowerPC, it will emit only once ptesync operation,
so it will be a minor performance improvement.

> 
> Suggested-by: Muchun Song <muchun.song@linux.dev>
> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks.


