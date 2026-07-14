Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37540C44501
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 15:22:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33EB56B0088; Tue, 14 Jul 2026 11:22:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 316456B008A; Tue, 14 Jul 2026 11:22:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 206026B009B; Tue, 14 Jul 2026 11:22:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E1F906B0088
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 11:22:05 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 73BD8A0338
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:22:05 +0000 (UTC)
X-FDA: 84987747810.12.337658D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 9672F140008
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 15:22:03 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CANWhE/+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784042523;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BCZ3Zd/UYddpYvSXSqBQQiGs1H+xK0sUqICRnDON//8=;
	b=6zlMJLfxHSabaWBuP43lLdaXT1LZ0VJ95ut3Hep/iD/KPIwepFAnFd6CsSXBrYSMgoRW4R
	AnxIV/Wpl1Y9XQxxFMz7Bsrn62a6MR7iXycXYMSJZObN7VGK9U7lotWLHM9T+BgOTDthfj
	gL7Jly1ZFdIP2qz7v2hyJIUie996hDk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CANWhE/+";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784042523;
	b=5lmGRVDfPYVVpcj92qzhYFCI7FUH3jHaGSqIN7ScRLoMbdsGHno1f5+khKbrfvwlTtvfhr
	+M7ZlUQV31Y6HwSpNRTRwy3pP8UJJwaKBBvk1aac4k47Ekq86LQITtUe7qaexLDYA+ghul
	BuAxFeqNFseGIaUUlekq9avOMhO5rfo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CB9624370A;
	Tue, 14 Jul 2026 15:22:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF35E1F000E9;
	Tue, 14 Jul 2026 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784042522;
	bh=BCZ3Zd/UYddpYvSXSqBQQiGs1H+xK0sUqICRnDON//8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=CANWhE/+CYS1FfUfjhITGX12OQ6kXuBnyec7afH9+c1HCQzcMYWlRc+wRLQApFBm7
	 unpSwxn2cqQC7+CQuxuxl2RdNFDAcen4a15J/XZAiipoB3Gp/ih8mMAoTHm0Q0zIdo
	 hisrSw/kpAmgG8mC6yZWDcGZvDIpqAzMVM+SJT8tX8frxA5nKb0Ou4yLgnOfisVO7q
	 n3PfiKP2hme6ksz8x8Rpmdskkf2CPQQeLdHtaVZWc+hbVyt2twbwUCB2X+LwMAPVs8
	 n/wgXNKWdpA6g3cbHY3wa9b60Y9vId0S1GdtplZG5kdaz/qX7UYQKFrl12Di7yyYS1
	 FTgpuHUmHLh7Q==
Message-ID: <c4895df7-bb9a-468a-b926-964f3cd40861@kernel.org>
Date: Tue, 14 Jul 2026 17:21:57 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH slab/for-next-fixes v3 4/4] mm/slab: prevent unbounded
 recursion in free path with new kmalloc type
Content-Language: en-US
To: "Harry Yoo (Oracle)" <harry@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 "Liam R. Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>,
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Danielle Constantino <dcostantino@meta.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260713-kmalloc-no-objext-v3-0-47c7bd138de7@kernel.org>
 <20260713-kmalloc-no-objext-v3-4-47c7bd138de7@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260713-kmalloc-no-objext-v3-4-47c7bd138de7@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: duif1i1t9rxtwx46741st9xr4unfdn9c
X-Rspamd-Queue-Id: 9672F140008
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1784042523-191851
X-HE-Meta: U2FsdGVkX19UHNw2l9tdjgGdTYLkiFlEkYPuqO55vU7St3RYUQrLAmHz3lU5u7s8Xs6G2Trx7cVCORWKdbGYV4Jyf5978e2y016AYl1v11u0prNKf8M5bxfvOPCs3ZHh/Bq4FBgLBEvbPdyOC+QyuycHo6sxrYMLHJHvQl4I+VRr6vnEVvnQQWpOVZUYxB5Ib/g8XMTMRS/zt7LA7WKa+UuaGo+f9U0go2M1CqpwM1WL6XGhDXyP2IpsVCAX3f+tDUWGxxMR7QNLyTl+m7vYHt9j3CoNGoq/jMFTDF4g6c0h3j4tFDo9/qKHyn/yUraFlLmi5vFSYhoZgFzJqm8RbE74es7FJ7jpXyvYcRHrvlQjSx698UNACvf0a0Fd65RipCTx+RZA4+E2nonVWG12rk+LXeTGVJWaVQfiPGBUOkYaG/Ge6kf/DtkmspNRO0hmTflIhpp1lei3vS0KVUqwaj2HUWvSglhW2sfxN6IZJkUL3sv2ZQtqqua8KFoIjebSzgLXev8WtCmXN6uMLPgdm6BaD7Dl1vBuJaI7zzK0WRv8zKFm0e1MMXPQCjNe7PctucM5Mgb13SgBccjMWMLuYD0JgVFjBt8tRzEfl8UO5hlZs6sLcNqfrL1PqUdc/usO9+brQqfIwmPerP+5Afw1vsymyAM4EDuendc62/FOYAOfmbmkyCw3bCNgMru+LfbKyC6gJJzxmleURFBhnvKmzh6ZpJbgsQxH7IHIbJ0vsRVy5zWglWJ8ap/zqzNQBrt+V5+Gsc2X7CN87JTTaazfB/h9ExrjrLeUlmN6JMWPU1/0+NedAiY/90XVyFcGgeaFDVkT0az/SGZfaNsS5qOYsEs1+wCEWM8n2HOZW2QtREgn4gpTm2yBarqsuZHN7wYvxnsel+IM1727RL36mSqL3tONPs42Us1wOhwcLuijHFUnCrN2JV0Bk+CapSB+NbeU5drlXQ+iDTui3LMsgv4
 yaZEsr+u
 539e+1IVg0Iuug3RS72Gsc+XADLHAAMO2wywJzb4AMN02M0DCCrhMEeguLFVDpUWE9cWe9fDrX/GWfpbS+RGqrMrbOcwYgXJhuWIpujFyEsSdUdi4lVJZEOzKZzOjjSdvBoR/CLHC3cWuZmWccyxFhyrz/K2cjnt5rJ8umLwDBel+/QZQ1DO6ABrg6gNnV6jHemMBIB7rTFRq1uC+E3xyz1+8y75UoI7dZfHXNwAl41oowwo6I1hLRV3BtUtNdL+B5f9A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 16:28, Harry Yoo (Oracle) wrote:
> @@ -2168,14 +2132,20 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
>  	unsigned long new_exts;
>  	unsigned long old_exts;
>  	struct slabobj_ext *vec;
> -	size_t sz;
> +	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
>  
>  	gfp &= ~OBJCGS_CLEAR_MASK;
> -	/* Prevent recursive extension vector allocation */
> -	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
> -	alloc_flags &= ~SLAB_ALLOC_NEW_SLAB;
> +	/*
> +	 * In most cases, obj_exts arrays are allocated from normal kmalloc.
> +	 * However, normal kmalloc caches must allocate them from
> +	 * KMALLOC_NO_OBJ_EXT caches to prevent recursion.
> +	 */
> +	if (is_kmalloc_normal(s)) {
> +		VM_WARN_ON_ONCE(!need_kmalloc_no_objext());

As discussed off-list, this can false positively trigger due to a race with
shutdown_mem_profiling() so I'll remove it.

> +		alloc_flags |= SLAB_ALLOC_NO_OBJ_EXT;
> +	}
>  
> -	sz = obj_exts_alloc_size(s, slab, gfp);
> +	alloc_flags &= ~SLAB_ALLOC_NEW_SLAB;
>  
>  	/* This will use kmalloc_nolock() if alloc_flags say so */
>  	vec = kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid(slab));

