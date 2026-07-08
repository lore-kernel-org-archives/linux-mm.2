Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DD32C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:28:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7409F6B0005; Wed,  8 Jul 2026 09:28:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 718146B0088; Wed,  8 Jul 2026 09:28:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62E406B008A; Wed,  8 Jul 2026 09:28:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33D5E6B0005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:28:02 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 937E41C6798
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:28:01 +0000 (UTC)
X-FDA: 84965687562.12.269C21B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id CBC7C10000A
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:27:59 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gq/dzTHH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783517279;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JZznSW1QxIA8YchHXYmBD7rqYjeBEHt8iCwtpCrWKE8=;
	b=K94+e7pxkUZ2FkATS2zEsSGdZBjFj5hmM+gTUZuIb6JOM+IjQfKtvs4NFSK1qKBHmpD/+T
	BvJyKnwvRv9eatEUQXZvpzdwuQ1gBwo3YARGRVL8ERp37BYHXpKb0WvKLBUFZr2FcRzucO
	AtIHQHHTGj+eQLz+7exsNlw2mOP+UmE=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gq/dzTHH";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783517279;
	b=wNx7ZO6ZE6ws32STpFY55vaAYMgrko53BpqNlEViJFmA1f11G+5kE1M+yG4LAGvDBxRh+t
	TScRLn5B4xsNcBpYcs/KWrWE4vsu4mqSndiB09p8VGaUlViLbSaIyqjigvp6K+FDXyRhBR
	2KIO7hncD/PKWwSH7XSm+9aLFX+KOt4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5BA6660054;
	Wed,  8 Jul 2026 13:27:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD841F000E9;
	Wed,  8 Jul 2026 13:27:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783517279;
	bh=JZznSW1QxIA8YchHXYmBD7rqYjeBEHt8iCwtpCrWKE8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=gq/dzTHHIPOEXl71Cphk3JscbEHk9Wo5plPjKBq+bmWbIWK56ZMHaxIrTY3KFY+HQ
	 A1X6ZaAvKvBP98O74jcXyYY1Jt17sg8z4ahhyBZ4hBhGUvrx3QnsUatXAl0GvrY2mA
	 BQf1+UYkt3LNEoOJEM5TKj9Yytsovd6h5eND+lOXK70SSQp/hlpBIIeP8jBz0DTn/K
	 bLJ5UDpxgmx4+LBs1R25AYDzr28o8DwJAlBFiH4+Tpe6HcMfRVhys5r4+jkmqXQj+d
	 jlcBzXBiitML/4/D1WNM/YlayTkznXQR0XwkZw4evyIWfphPLUZmYlJF0mYzNB5+Cx
	 JW+BxXzgtWlzQ==
Message-ID: <529e3997-d26f-4d8e-ad90-3329fe90e555@kernel.org>
Date: Wed, 8 Jul 2026 22:27:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net-next v3] net: skb: isolate skb data area allocations
 into a separate bucket
To: Pedro Falcato <pfalcato@suse.de>, Paolo Abeni <pabeni@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>,
 Simon Horman <horms@kernel.org>, Jason Xing <kerneljasonxing@gmail.com>,
 Kuniyuki Iwashima <kuniyu@google.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
 Kees Cook <kees@kernel.org>, linux-mm@kvack.org,
 Vlastimil Babka <vbabka@kernel.org>
References: <20260702170728.168755-1-pfalcato@suse.de>
 <04debe19-bbe8-4b5f-9668-753d1f97832d@redhat.com>
 <ak4w2k4Woj55E0On@pedro-suse>
Content-Language: en-US
From: Harry Yoo <harry@kernel.org>
In-Reply-To: <ak4w2k4Woj55E0On@pedro-suse>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CBC7C10000A
X-Stat-Signature: 4yjxcgtffws4djq46ub8jef67zxehjyy
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783517279-659592
X-HE-Meta: U2FsdGVkX1+UfQ9iS83aOmxGld0SfoovOu3qXyiw5NM+eRcEOsXZdC9eODpVvYSZY6gVjtjQaBsU8OCwrfbe1uTdrVpiAx+6O1ApgZAV5fJRD4mivh0q7bsAr9Kpj/e/fDXAbpPDt7lTcli47SC/Nv8q3h4RGfIQbiWmWmt0mvjH/hiwRtxoKQwJd+48nyYvjKf7h3aPK727B7DJfv7p8FibTQCwU/yZmsPNq1r7svuIryMBCarH2UpixEFu8PgsuWA48BfJFpIqOi1LHiCZPkOoFqpAK8+rKih21oDydpulsMpgZ0YJJV4fpF3XBpTJQRzOImrFAc4nu8lmLZhnhMsf8fFJ+AbQlQ2aLq65yFh79SVtdCDZNb8YGAbdgbucO9QaUXVn4gY2mrklRzHJlLYkN0Yixc4E19XvP4254WZcnnShnHTk5zFwHZ1n0bJBErRXAYqrEbW8GdTucPJCU2li7mMFKhJBRTs8ev0kxrqDNDbu8xN1J+HQ3tpZBQIGny0/GtWRoxBAVCFUxrzgfYLbJZyjtv2p/9izaY5tJfqDFk1vLqATXxPbiYd8bAuNORwRz56KUYI+tRQEfco9anjnok10tVZoXKzIsBn8Sl7PPUS9kqCt0BX5YD6bAXeCwHxcHO765VJzn40xNV7nLoa1L2lHVACc5v2uu6YRfqQeA0y/LKMHhYMRXeEnUI5+DR31oSG3R6xnQ289/J7GIFiazulDTgF74VHcGaFHdkLbKAubR1WEJNzSlHg2Qe5Cm45CPv+2FRnDDNCHMhAZsksWRzzcJrngKOLsm6z81FDAQFVOGesJ3p33GJQHK3mWylM5Jk25BCyNRbr2HQsR06pc0zvMRCDztflSAhRUIEXPKmuyZci85Qe1yq8/jk8Glsa5OGzXdLj3pTQj+vLfDEMlX5fPbnafFstMxQ2vMYj1+zRah6v+K2tdrWq+BEhBulBim6HAqSUEuWsfZ3y
 WY3vDhVf
 Fi1SgCJHvxPlEDSSUAvWxUn+68M+xNFE0wyjyko2ujC4qx6UCRBzidhQJcPDFDXlbaG/7f3G0ypOtkmX5ZUOSVr59CDxMckysNHf8wvwjsOrb3unoG7qZhbLmFb7ZmKEGsC7RsAWj9/UkLHkOFnf0TkWvuYO8gha0szSebYEiUp8Zr/ctlmCGgrUuVBV/gqZCIYjw1djRzcMVe9WhlhUmylTWiWEnfb6vb8ZAJNiOvIsQiaVZYpGtUiCsQfQd16aGm7UlM1GN8WcXxvUwKR6xP6nFHiGLFVRt6tcbveViq0q5jW06Q3VBId8/k/vYTbBXK8k3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 7/8/26 8:16 PM, Pedro Falcato wrote:
> On Wed, Jul 08, 2026 at 10:30:50AM +0200, Paolo Abeni wrote:
>> On 7/2/26 7:07 PM, Pedro Falcato wrote:> @@ -586,6 +586,8 @@ struct
>> sk_buff *napi_build_skb(void *data, unsigned int frag_size)
>>>  }
>>>  EXPORT_SYMBOL(napi_build_skb);
>>>  
>>> +static kmem_buckets *skb_data_buckets __ro_after_init;
>>> +
>>>  static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
>>>  {
>>>  	if (!gfp_pfmemalloc_allowed(flags))
>>> @@ -593,7 +595,8 @@ static void *kmalloc_pfmemalloc(size_t obj_size, gfp_t flags, int node)
>>>  	if (!obj_size)
>>>  		return kmem_cache_alloc_node(net_hotdata.skb_small_head_cache,
>>>  					     flags, node);
>>> -	return kmalloc_node_track_caller(obj_size, flags, node);
>>> +	return kmem_buckets_alloc_node_track_caller(skb_data_buckets, obj_size,
>>> +						    flags, node);
>>
>> Sashiko noted that some drivers may require GFP_DMA buckets, and the
>> above may break them:
>>
>> https://sashiko.dev/#/patchset/20260702170728.168755-1-pfalcato%40suse.de
> 
> Oh, this is really awkward. Adding linux-mm and slab maintainers for input here.
> 
> Considering the current slab bucketing does not seem to duplicate DMA or
> CGROUP caches, could it make sense to duplicate those as well?

Could we specify what kmalloc types the user needs when creating
kmem_buckets and duplicate caches for the requested kmalloc types only?

> Otherwise we could add a branch like:
>
> if (gfp_flags & __GFP_DMA)
> 	/* use the global dma kmalloc caches */

-- 
Cheers,
Harry / Hyeonggon

