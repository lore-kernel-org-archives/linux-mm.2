Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F78B606A69C
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 04:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=B6h7mEeR
Received: by kanga.kvack.org (Postfix)
	id 6AD066B05B1; Fri, 20 Nov 2026 23:20:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E1D6B05B2; Fri, 20 Nov 2026 23:20:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54D846B05B3; Fri, 20 Nov 2026 23:20:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2F9496B05B1
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 23:20:09 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 95EA01202FF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:20:08 +0000 (UTC)
X-FDA: 85457823696.02.78646D7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 07E5C120005
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 04:20:06 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6h7mEeR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795234807;
	b=8f+/C5l7g4fGxEGQNj1ZAoe7pxrjJhT2rdROv4dVyrmgnJo/NOy6IVRBU7pdKPdpLzZvoq
	SneYtB7xlT6l+teBgv0xBvHRjPIYrlxDHjRmknR4ywuHB5Ial3xYModq+YpWwCU8aOfKWj
	M7AUsphRlBKtGV5qNePCChH+HRUq1q0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795234807;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m3vBbC7lB+1mVcxJ5atawTX+EVeRE8qP3n/h7VzprXo=;
	b=SfS4sO8ywkm/ohWafTEe7njBLMCP34dTsvodho2J4XPYbz3kYGQcnpEbHo9qdqTkgaC2/a
	H4iHygRd+jUwfKw6H0z5p7brs1/QlyivNM9FCaRoBPy24cpNzBiIPLrBHaslcZrpzUdmb9
	W2WCcOJ0dfQK8hBc27JAFx46Mc4u8Sc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=B6h7mEeR;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 380C36062F;
	Sat, 21 Nov 2026 04:20:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E7211F000C0;
	Sat, 21 Nov 2026 04:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795234805;
	bh=m3vBbC7lB+1mVcxJ5atawTX+EVeRE8qP3n/h7VzprXo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B6h7mEeR1Mv3qoAzE4yw+PE46Iq0LrN+52Lm/HS9ht0fe5qlh80JanfLMQfrtaZOE
	 DIm84eFrBlVtY+vuIVc7D4BEFKEg06Zwpr7Fc2S2sf1J6oJPSC322ukSfOhFGUGlYA
	 tfiHrFYJjpwDT7OQXQ3m8H5mt2mXcjwU3oN/XSVvXS2xeZxITKU7HD+pJSNBi5YJXB
	 OVLiSdC4KaLxhs5Dl0z08RqkZPF86gcKwnkVErNnpSSxHpBMWCMBH7zP9MvFIw4E1A
	 xyRaZCsPFGjRzBAd6GYanovcFiCjKDxbmbPSF8Orj8k1WFzuRuNtiTg6TRydV0Lpay
	 EWaw//njTwELg==
Message-ID: <sashiko-outbox-226635@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 5/8] mm: zswap: Store the folio's node id in the
 zswap_entry.
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>, hannes@cmpxchg.org, yosry@kernel.org, nphamcs@gmail.com, chengming.zhou@linux.dev, akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, davem@davemloft.net, linux-crypto@vger.kernel.org
Cc: rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
In-Reply-To: <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
References: <20261120041906.5785-1-kanchanapsridhar2026@gmail.com>
 <20261120041906.5785-6-kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 04:20:05 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 07E5C120005
X-Stat-Signature: kgw9g5uhiz7edurjzkkbmfqdguh88zfc
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795234806-691309
X-HE-Meta: U2FsdGVkX1+u79xS77PC0ghMo5mGoZ+Hc44TZbw+mHpwcocD1ylcDEUvZez9Ibi1yrIh3tWhsnP/3jFITkk+RAECtU9TGP8h72NQJ8lIbgRAv48pRJgB2dB57iy/7YaR5L28sFMDFTlab15osaSlx/HOKSChTJoa95Od0lImaXL3XvDFTBnolI8fefmBglhFg2qPirmh0bxJuK5jn1l3yE6Ogm0JVCcNBTVGcrQ5ObgzdlKsRXcK4uB7BVCW5nyJVl8S/neG+4h0C21MhplfP95kK0k5YMsyUZ90jvB7Y8mdggwMc4GqAPyfBF8YXUSljs5y3Rd9HEVlm15iLeZjdX7ovCS7nFXa2e8bbm6Cqs0eJxnkmVf3UvO5Z6QcPh6WvL7G6yQ7mQGeXrSewPb72k1VsywrMQ5g/3MlrCXSNT6pRGbnGbRyjaxahYhoIi9c3/kfr0SjHbDrsk1CJQSNHIWU0u2zfTh/bi2ndi4Ck0ruNdg+hRxuDt/P2J9+FYoK8Jy+9Eff4clHvuqUpzLw25TCKvYOPy4ij6wlIH+pls94hOODcDy2PqmDiA6mLyo+OaditQFL4wkc3ZNU7JZt3NcLlPm1MrTPFO/NH4RLnT/zvL4CD4Poku2pNHyTSmsRGPEb0GZ1aj9AAYROIe4CXkeyuLwOJ2xDoPUXb1/wS3tVEvH4hTpb3jP6gasSqOAyeLvvRx0+J9aW/0srXWDpWunMtBFarui08+E1mh3Ojc1lUDY6wZIJ4qiQXu1aEMpu5YhYoeerqM0UidDDH0ikpsGAkZJkXAXaHisEKpw4iQGciM2NI632ZfaoP99OI3gu/fTGeFItPjrxBf2EoFdR2phT7hBeG2SFb8nx8DVQNvRWdaRe1JYGWCuX3WnWDKnt6TqbNxnssC0DFOTuYfONSDHFaKmfqt6zVRzWjukRd8jGBKLKUVGvOKUh1sH/r0CwnoDkrAjFDuKFDkeGMZi
 H6QXC7i7
 dbYQyCTGbDgydD9o6BbXw+IIFJZqQY7uVhyuzaF0BOyLaWBlO1bDS6tcD3ZPe/ceQsAUDzQsbZThX/TDSA7f1DPdR4AUB3VkJYVVgI7xFVX0H7kvNt7s4i5j7ZxoR8Rbnsgxsg5SryVfDO6dS9DPayxbWf7jamc+nKfizSsQiol6+n96MzBvDWgqc7FrlgyVNzheoiYO5FzybHHZsyo5eBYtRykocf4Z1qm0kHkKXzsgu7Tz9AMsskL1UDNJYUzYy6FauvMmchUb2kJbMzzSEVSi8+GHOENBLhFfnyGY1qehtFgCwtCzZZyg7jmZ1Cjt2TfIRt9Q2vOMzIs8KJ2vR1Yj0VQHiD+MdHkJjfG6sAh1wW/0U7Rdb2Lnu/8coozYS5hGe51JZ50rVJF4eoOmg8aVKnWH284uWXng9cFc87G/bXdbRAPzQ4oP1cNtXiytfDXHm/qGmZFkfPUS0GyekXfcoUTtLgfim433Z8H8WBaazgvyna/hndWN5zhPp1JbXkgMlhZziZ3/pQmld0wu8PaQV6AG83IvCUg6XrJ2fFfMjQd9nGw9SYxA+YjF1OzDNn0/V3uLtDnlLC2v8HstHUykxPZMx1jTlQ/57DfNlZ7z0Gx8F7cevVKjoG9g0La0nl5QdAJKpw2EP/uU1rJcZ3MFf23CEOK7SJ9Pz1wJ3qWjmCt1NUc01PFuZOCpTzilwxXwkx1YseGT+xQwzD/FyY2fpdx2DVzUmL6409DNoqk9IWK+vHgKGsTligXh5eHgI6HkITXW1045NiCEwdhTdRUGCs+2dBI3blFEOvcAjWFHF/b3Ku+10Rn3xSxb13glQ/xvoYmD5RQRyHCPesChHPuINw9c7wjgbLYaR/TtmLla73CE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: zswap: shrink_memcg() skips non-N_NORMAL_MEMORY nodes in
  zswap_list_lru
--

commit e4e47a21782dc39867fe81289fb7e9ed7f2692b4
Author: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>

mm: zswap: Store the folio's node id in the zswap_entry.

This commit stores the folio's NUMA node ID in struct zswap_entry and uses
it when adding and removing entries on zswap_list_lru, instead of deriving
the node ID from the slab page backing the zswap_entry.

> diff --git a/mm/zswap.c b/mm/zswap.c
> index 9a323862bd59d..78d9694f75b5e 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
[ ... ]
> @@ -680,14 +685,8 @@ static int zswap_enabled_param_set(const char *val,
>  * lru functions
>  **********************************/
> =20
> -static inline int entry_to_nid(struct zswap_entry *entry)
> -{
> -	return page_to_nid(virt_to_page(entry));
> -}
> -
>  static void zswap_lru_add(struct zswap_entry *entry)
>  {
> -	int nid =3D entry_to_nid(entry);
>  	struct mem_cgroup *memcg;
> =20
>  	/*
> @@ -704,19 +703,18 @@ static void zswap_lru_add(struct zswap_entry *entry)
>  	rcu_read_lock();
>  	memcg =3D obj_cgroup_memcg(entry->objcg);
>  	/* will always succeed */
> -	list_lru_add(&zswap_list_lru, &entry->lru, nid, memcg);
> +	list_lru_add(&zswap_list_lru, &entry->lru, entry->nid, memcg);
>  	rcu_read_unlock();
>  }
[ ... ]
> @@ -1537,9 +1536,10 @@ static bool zswap_store_page(struct folio *folio, =
long index,
>  {
>  	swp_entry_t page_swpentry =3D folio_swap_entry(folio, index);
>  	struct zswap_entry *entry, *old;
> +	int nid =3D folio_nid(folio);
> =20
>  	/* allocate entry */
> -	entry =3D zswap_entry_cache_alloc(GFP_KERNEL, folio_nid(folio));
> +	entry =3D zswap_entry_cache_alloc(GFP_KERNEL);
>  	if (!entry) {
>  		zswap_reject_kmemcache_fail++;
>  		return false;
> @@ -1554,6 +1554,7 @@ static bool zswap_store_page(struct folio *folio, l=
ong index,
>  	 * to an unrelated live pool.
>  	 */
>  	entry->pool_idx =3D pool->idx;
> +	entry->nid =3D nid;

[Severity: Medium]
Can shrink_memcg() miss zswap_list_lru entries when a folio resides on a
node outside N_NORMAL_MEMORY, such as a ZONE_MOVABLE-only CXL or
hotplugged memory node?

Previously, entry_to_nid() took the node ID from the GFP_KERNEL slab page
backing struct zswap_entry, which was always in N_NORMAL_MEMORY.  Now
entry->nid is folio_nid(folio), which for GFP_HIGHUSER_MOVABLE folios can
be any node in N_MEMORY, while shrink_memcg() only walks
N_NORMAL_MEMORY:

mm/zswap.c:shrink_memcg() {
	...
	for_each_node_state(nid, N_NORMAL_MEMORY) {
		unsigned long nr_to_walk =3D SWAP_CLUSTER_MAX;

		shrunk +=3D list_lru_walk_one(&zswap_list_lru, nid, memcg,
					    &shrink_memcg_cb, &ctl, &nr_to_walk);
		scanned +=3D SWAP_CLUSTER_MAX - nr_to_walk;
	}
	...
}

Entries stored from non-N_NORMAL_MEMORY nodes will never be scanned or
written back by synchronous cgroup limit reclaim or shrink_worker().
Should shrink_memcg() iterate over N_MEMORY instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261120041906.5785=
-1-kanchanapsridhar2026@gmail.com?part=3D5

