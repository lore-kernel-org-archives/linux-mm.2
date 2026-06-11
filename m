Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 196CFCD98D2
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 08:51:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B6056B0005; Thu, 11 Jun 2026 04:51:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 28D956B0088; Thu, 11 Jun 2026 04:51:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 17D216B008C; Thu, 11 Jun 2026 04:51:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 077AE6B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 04:51:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 191EDC105C
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:51:28 +0000 (UTC)
X-FDA: 84867013056.05.9FE9EA8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5894AC0009
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 08:51:26 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VLSc6bFy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781167886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tKQY3q8LRG8SYeUWFL/Ai08b37v/C5UOx3jw/kl3HVc=;
	b=bEn/q8EDrZXJPcxGUhXr7LmLbDszVZBQk3Y8//D9Xd7JRH4iGZeuLeGl5SoUsTdUq2V3MJ
	Piz2MlnGJ44o22lxTxjHnvuyX6rElTLFVeKS6pko922xfJyWl4WcGOtIMIETPrDr8mqTPl
	QUVe/ov5w7fqnwyHpGNPs1iu+NUaaT8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VLSc6bFy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781167886;
	b=VlGw6e/qQnNzF9FEn1c3UuRcgpBrfeWhWPM383Bu9epPem99G5mFK6N/aOVj+zKOrXwXK9
	d7VBoC66+1esIrUsPsdjtDXwzXBWncg0sSUcxZzvNyrZVf8uiWsU+spe3O51tKfiFwtXhW
	bJgVUQGssXYgLaVlxUoErvXvTFdGDUQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CDD7B6001D;
	Thu, 11 Jun 2026 08:51:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4DDA1F00893;
	Thu, 11 Jun 2026 08:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781167885;
	bh=tKQY3q8LRG8SYeUWFL/Ai08b37v/C5UOx3jw/kl3HVc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=VLSc6bFy8Nf4LrmeiH/AXvTLCsV4NmbpcD+RqmKowxdCB1XJ6GSorOidWsAd4Uc5T
	 cseJqJ1r5/e3+o02SKnJt8sUffKyjuanvLaH/EHDaUBaQaIdx+11MPWKFNU54d+pJr
	 eUnRU5ZW3nhYTCiK5cq6v0onacSYnkHWChRIcX/73nFH8qqhno503WbUOZwd5UxmyE
	 0nAlFbjS6CX0CfGZfd+aV+S83PbRSLb1lyVM/skhZY72WX3YAHAWmwmYSVIjAiYmST
	 v9nTzgZbn48/SHfr/DDBNCgFZg3dCsAED04OD3TI6YTfAgfPIYnQMhDcN9IjKSEKOw
	 QJ1/z6NJyo72Q==
Message-ID: <3d6e1e47-efea-4f4f-889e-ce5a89cf808a@kernel.org>
Date: Thu, 11 Jun 2026 10:51:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 05/16] mm/slab: introduce alloc_flags and
 SLAB_ALLOC_TRYLOCK
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
 <20260610-slab_alloc_flags-v2-5-7190909db118@kernel.org>
 <7064a90e-4bf5-4be7-8b7f-a5a11dcee66f@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <7064a90e-4bf5-4be7-8b7f-a5a11dcee66f@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5894AC0009
X-Stat-Signature: s8yxd1yrookm87rtfuaugg3nnsc66awc
X-HE-Tag: 1781167886-223760
X-HE-Meta: U2FsdGVkX1+kOeYskiW/H9h1UaEgLjegYt5Z82SrFA1AcHo6wCtY0oRMl8dPJUnYQSy/JTAoHbKgIi61mV5OvXcJolEx33vIMzl86vR2RJ6rg2w9W73W98vHwERRC7qvNSb2p+aADP+mDWzNLPa/imqj+N1/8p2Ajekyq7ujwL/4Q+C8t2hZaTDmVGsxFzLm5orCML0gRG5j3aQcTtMZBDTkMO4LujadH2b8SHokJ/9vSzLEOvrJFMsYLsPqzuMKAg3desI4+y0kL/KnHDcrlNNb2t7B+qgg54zwpu10ZrpVEhvlfOuYum3vjSr3OExAZGtGSlMWD3eleQ3QNovncjFkTrT+KAXjwfLeKsvlV2S8NNvLdWsy8PnjCRqY2n4MNdaWnKNXhPKV/unBHWxbI5qpSX7+bI1gq04Z/NUJyaQG+/xw2wYV6HYuweSpGBSEGtukCKm01SdZyorNBkU8r7xG01DfDBaBabkHqLSDaJzsrABdW4/ktUHkwEyHUjoKGi9BpXmVm7IyNIwP+rxFuBVL8QisbCCoJMmpDCDCw7Jug0b8H0m1KVrqmJ0wUo97I+sWMkv3jReFRw4h4uxyZN7uNrRcH5/VaU3Z1eVLA/yfotaXRv6gyIA+siW6uSMcaTx+f9rRdjGBjFCm+tpw7VGnFwsWIi0GSbMivzih4VBOeuICihUu6hStNQCwDLGTRYD4X2TYambJXP7BMQBajRVmuvbJ7DROz1IZb9demDgFxqqYXMkHAqzp68Pz1BMkBfUCZdYLeA+2smNVLrnUxVxhKqFMoSKTFPliD0h4+Hib+s7A6PMy7U/lJaGV8HxG/12vpW3HsCVhtEaSKen72KqmNuQocY4Zo5ZSPO9u5yT+pxs81i8pBJ01SehGZt+Z+Q3iw/Ls8K1whTQ+wUfzXaWq0LazbLBlKyNsBjfaB3GGrBkxV4lNdAsAbuPo3l4f/ocTKc40GKzTxzq2Dip
 RaOKFTeq
 MoYjfS81JrX40haKlryNMsERpcHmmvr1esYgQ+LXl5tFLI5eVyai+z+Ip/sFWU7OOmE8oKc+c2YgLm4Q4t2vMVMOLO/0/XJlJsA5LWX8JtDh1PDY68KUInNj6ty2D9jQk8Ao6k2W5no+ZJ95qtkq2qMPzJI00bWNoHxImJrp176uxKDrmbC5G0mEEdKHzgS6tZELVxpwq78pW/7K3JKrY8UioJjG469eju0pQmkjoKPoAEPOrHtjHipnQz8JlUmL55C2NcKAYpQWxfFsnbyxgsCzJTYCCIuTcBIFQqdtQvuqDJGlLU5p8ijv3dWQuBIC17Z1X3W9cAaV+oCiTdetxtZgHfLADYqIVpqMk6n6TAPHEe8FtbZ+NUSwhm46BLwjrP7pdxZaE4GtPTFM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/11/26 08:40, Harry Yoo wrote:
> Sashiko wrote [1]:
>> Does this bypass the caller's gfp constraints for standard allocations?
>> Looking at slab_alloc_node(), standard allocations now pass
>> SLAB_ALLOC_DEFAULT into alloc_from_pcs():
>> -	object = alloc_from_pcs(s, gfpflags, node);
>> +	object = alloc_from_pcs(s, gfpflags, SLAB_ALLOC_DEFAULT, node);
>> This default flag means alloc_flags_allow_spinning() will unconditionally
>> return true regardless of the gfp flags provided.
> 
> Yes, but that's not used in _nolock path
> as mentioned in patch 6 description :)
> 
>> If a caller allocating under a raw spinlock intentionally strips
>> __GFP_KSWAPD_RECLAIM (for example, by using __GFP_NOWARN) to prevent
>> sleeping,
> 
> That's a horrible hack (and hypothetical. Nobody should be stripping
> __GFP_KSWAP_RECLAIM instead of using kmalloc_nolock(). That's purely
> broken).

Indeed this was never intended to work, and was just an unfortunate
sideffect of the gfp flag reuse to implement kmalloc_nolock().

>> won't this allow the allocator to execute spin_lock_irqsave()
>> on barn->lock or n->list_lock?
>>
>> On systems with preempt-rt enabled, a standard spinlock maps to a sleeping
>> lock, so taking these locks in an atomic context could cause a scheduling
>> while atomic panic.
>>
>> Since there is no nolock variant available for custom caches, do callers
>> currently have any alternative mitigation?
> 
> Well, RT kernels are not supposed to allocate meomry under a raw
> spinlock (at least w/ allow_spin = true)

Yep.

> [1]
> https://sashiko.dev/#/patchset/20260610-slab_alloc_flags-v2-0-7190909db118%40kernel.org
> 


