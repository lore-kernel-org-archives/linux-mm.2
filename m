Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68A9AC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 11:34:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 802466B00E9; Wed,  2 Sep 2026 07:34:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7D9B86B00EA; Wed,  2 Sep 2026 07:34:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7166E6B00EB; Wed,  2 Sep 2026 07:34:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4F7636B00E9
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 07:34:44 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA639C01B4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:34:43 +0000 (UTC)
X-FDA: 85168614846.19.C1C9B6F
Received: from mta1.migadu.com (out-135.mta1.migadu.com [95.215.58.135])
	by imf12.hostedemail.com (Postfix) with ESMTP id F0E9E40002
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 11:34:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cGbEubHa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788348881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HP55G3G7OR7tPXH6b6MwTZu9VWaJQX8UNAiki3yDcWo=;
	b=JqH5nkS41yUFiI5aIpeyxHqg4WwEsCKMaOig8+MYV1EkWcyCdo/FqRiO/boqkpByOQnGcq
	EHONsWO3GXSh+pc3fLfU1HyEp3r6Y86K4CzSl7OZw1oy70+60uNNi845nMISJFI8EeG3i2
	qQcDH8Zs/CKjZrlBgLsK63Zfwqnpp+E=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cGbEubHa;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf12.hostedemail.com: domain of usama.arif@linux.dev designates 95.215.58.135 as permitted sender) smtp.mailfrom=usama.arif@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788348881;
	b=i9qPuI1sc4qdugvdRKfQU5iqBktLd+RydrnQBG+g/K+KU4hDP3eDYgQB0HEIRkkvbqhRDh
	QRf9EcjNQ0OwuaYEPZSVx2HU4WyECYFUZr+Q+ewgspvMkaBazv6wnHov345AgPimLxnsKf
	AAlg4FPf1s1G4OfnJfDSdFFrZDKEFgg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qjw5gpQggZH5kMdGCrNH15qunf+SR8sJSyM7R3/MV2c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1788348878; v=1; x=1788953678;
 b=cGbEubHadqfrVll+7NNtWQIYnPU686kaQlFqGD/JIMkOVW5ieqSumYnRxe7b8rcwbG4Iy3Oo
 ANgS2U+7SDLV1BWt0vhTI4YP1DYyfGKEy6pX3btbTHmpEAPOkc0XC2m8ZbEZs5R9BRUcZP8W2jC
 MLNZIDIJAoaryukC8TxW+woc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 0649d5faa369876e;
	Wed, 02 Sep 2026 11:34:38 +0000
X-Mizu-Trace-ID: 0649d5faa369876e
X-Migadu-Flow: FLOW_OUT
Message-ID: <5753d853-df04-4918-9852-c23842c66428@linux.dev>
Date: Wed, 2 Sep 2026 12:34:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/shrinker: fix bogus set_shrinker_bit() with
 cgroup.memory=nokmem
To: Jiayuan Chen <jiayuan.chen@linux.dev>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Dave Chinner <david@fromorbit.com>, Qi Zheng <qi.zheng@linux.dev>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Kairui Song <kasong@tencent.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-kernel@vger.kernel.org
References: <20260902073800.305481-1-jiayuan.chen@linux.dev>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260902073800.305481-1-jiayuan.chen@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F0E9E40002
X-Stat-Signature: hn5zmwuqqqp8a85fg3qkgw7ihsgb8dgk
X-Rspam-User: 
X-HE-Tag: 1788348879-464133
X-HE-Meta: U2FsdGVkX1+4KC4epSKdq7HeohwnC+QUxtWvudoL6QrPPwc3Y5vq6QDKKzactrBh2e5+/WMHQV03+QoDiY5T7m8vc/BSlU+3gwhfG62GAJUUrGC7sIO8C6qeJu1HGEHia+oK+AVlrOXsd4FDED7pOGuFK8LcI6NZkplJMZKcDAE1Zd4ZWGep55EMIzDS3kEuXVXtlbarp1KlhcLAYjVYrvl3xrRHFnUZe5YFTPFCcLybnR6mItBMnjJNLb9aZnv9fBvTrvSnsm2VINMImVDlSpsCX1bE0CnsPAvCVEgnZCetKsP3w9+FBx/ZNwcdNK3NJOwi97FkARlpw33r8QqhlWywZ4sCo/fWsjjeBNZCqtoHc2/DTNfEii91E6jg/WnTdRGnOF9rZf+q3BYWm55A1+ISjARWNunZdBGxIz/dfoHhcRl28nf855aEmGa88mH0a16dW0mWaKYpWT1Wsl/xSQYAMEDOssU7OD3qegQORl+QAkqJGjia6k8YWpPcnCTHBqtdG3YADQfVwjfieGomhC4souoEUOJfuoSMHJR6bqac1q8KFi0VIAFnkZFgG4nIEqC3L5RDB2Ac4wZGfcc2GSLxYdLqTd3IUgi5GbLYVRKg1cgFEn3gONTDSCmohPWAN6OPUNKOqDuEGBcLSKd8pGCtZaE61a8wb0hUoufMacczZTInOlVEHq3xMdxE6u56P/flmEH51bU8gwQLVf6LmfsmaPQtmU8qpGcTWqPQ5x8FVSDTrmcY74Wz0o2Q8Dul/g4tYSSXuILB619VTCJHZlLzv6Hyq+ADgTGJVdaNinZutE5hbH6IfLsSeR3ytCBxvvtxwcFyqFZgbGm2IN0emy6XV8vwzTVtGk1wu0mjhBHGoGFB6lYWD2e2jW5FtwhRFu+1Vus3s12qq15Ffa4DurGdkA41jBouKQtN6iCs4pUMDCoaK8w7Pldo5sMonnORcQ9t5+TTLUW1buMiHIn
 KEws5/8k
 KiSBf2QnAuKdqc/YkKIpQAd1ZeX0PUMGb4mzOhPeJBMM5ppZSJbYtASBE8czArAJlOmUhOXSnZo7ZKfQBejERn3oJeOEqwRcBDHApcBqlGOiRv0NaKLfyEKKg/lqTixMTqjTrRb5aHpiHYvPkF8XftHFWHjVMn6lkDWPPuU2IB3ZAXTORnB5NqDaCMjRtxltjvacFXR2Em2pd4/QSoFNx1E4aZvOPUDLl68Bxwh3Vy6yR/2pa8tjgOfMD7bi/mY8IhZrPtRalwJ+FUoc8OLwLcwIhzHUwm3jNKxjPQF/JjkrkGN/r2ghdim3ycyS/d3XWLVWo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/09/2026 08:37, Jiayuan Chen wrote:
> With cgroup.memory=nokmem, shrinker_memcg_alloc() bails out early and
> never allocates an id, so shrinker->id keeps the 0 it got from the
> kzalloc() in shrinker_alloc(). __list_lru_init() then copies that 0
> into lru->shrinker_id, where it looks like a valid bit index.
> 
> Nothing calls expand_shrinker_info() on nokmem either, so
> shrinker_nr_max stays 0 and every memcg ends up with an empty map
> (map_nr_max == 0).
> 
> deferred_split_folio() hands a real memcg to __list_lru_add()
> regardless of whether the lru is memcg aware, so the first THP queued
> in a cgroup does set_shrinker_bit(memcg, nid, 0) and trips the bounds
> check:
> 
> WARNING: mm/shrinker.c:212 at set_shrinker_bit+0x7d/0x90, CPU#126
> Call Trace:
>  <TASK>
>  deferred_split_folio+0x18c/0x220
>  map_anon_folio_pmd_nopf+0xdd/0x130
>  map_anon_folio_pmd_pf+0x14/0xb0
>  do_huge_pmd_anonymous_page+0x1a1/0x620
>  __handle_mm_fault+0xea9/0x10d0
>  handle_mm_fault+0xe5/0x320
>  do_user_addr_fault+0x1cc/0x870
>  exc_page_fault+0x81/0x1b0
>  asm_exc_page_fault+0x27/0x30
>  </TASK>
> 
> Harmless, the WARN_ON_ONCE() is what keeps the out of bounds unit[]
> read from happening, but the id should not look valid in the first
> place. Clear it before returning.
> 
> Two other spots could paper over this: drop the id in
> __list_lru_init() when nokmem turns memcg_aware off, or make
> deferred_split_folio() pass NULL like list_lru_add_obj() does. Both
> leave shrinker->id lying around for the next caller, so fix it where
> the id is handed out.
> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> ---
>  mm/shrinker.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/mm/shrinker.c b/mm/shrinker.c
> index a70aab124a0e..7ec2a9704f6f 100644
> --- a/mm/shrinker.c
> +++ b/mm/shrinker.c
> @@ -227,6 +227,8 @@ static int shrinker_memcg_alloc(struct shrinker *shrinker)
>  {
>  	int id;
>  
> +	shrinker->id = -1;
> +
>  	if (mem_cgroup_disabled())
>  		return -ENOSYS;
>  	if (mem_cgroup_kmem_disabled() && !(shrinker->flags & SHRINKER_NONSLAB))


Thanks for the fix!

I think the initialization would look better in shrinker_alloc()?


