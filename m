Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6A723CD6E56
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 11:09:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD9816B0327; Mon,  1 Jun 2026 07:09:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A89466B0329; Mon,  1 Jun 2026 07:09:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99FD06B032A; Mon,  1 Jun 2026 07:09:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 870C66B0327
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 07:09:53 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 543891A0604
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:09:53 +0000 (UTC)
X-FDA: 84831073866.16.17CE966
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf11.hostedemail.com (Postfix) with ESMTP id 73C6A4000A
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:09:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fwuYrdm1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780312191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTr4tQwBByNMsxp8D3ocf5yh1cG3xPQPohe/Uv/Q2R4=;
	b=Ks60WDmVarUJeKuhtqaDf6h3KLNEszj6wl8qACIXzXrQBA7fCB8i8YxKZCXd5lY+r+B6nu
	LwUnGyVNRlVnUbqG5M7T9FplVepp1WUGl7h2MduVv6hK9Q3W1B+v+HiFK7Tlsjs11l3gNl
	WGlkcBPfILiiNsyvTF6sjCuOS8yAXe8=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=fwuYrdm1;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780312191; a=rsa-sha256;
	cv=none;
	b=vTTWK+bdv5McCW+i3/OqrG0gqqk2W5wdIoi//ldZA1G+keyEjmwa5CLKi3i9Dn8+qW0uU9
	kVGmh5EkWy6KOhNyzsLo44+t94r8R6C0nZMl40pCtdoyvyJ7slje+/hP7jcWVJOPhro9G0
	epNDIfb46/5PtnQBYzr2Wm4kknuLfCQ=
Message-ID: <c9cf7afb-1c92-4915-b311-305c7ac48739@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780312189;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TTr4tQwBByNMsxp8D3ocf5yh1cG3xPQPohe/Uv/Q2R4=;
	b=fwuYrdm12vhes1RUcQfe5De52w6tNFQ4WjqITT2oAJkvclwo0eQiv9oCvrJTOzfOdF8EjN
	pUt+rMTOaFp6fdp8WsZ2kzw7Yw6so77nPChFnq5PyPwRn8wgss95ANbm+qnIdMMjsuLu27
	ToMkL/pgiC9lFr1RSqNcPITzxAXrMA8=
Date: Mon, 1 Jun 2026 19:09:34 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v5 9/9] mm: switch deferred split shrinker to list_lru
Content-Language: en-US
To: hannes@cmpxchg.org
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 shakeel.butt@linux.dev, mhocko@kernel.org, david@fromorbit.com,
 roman.gushchin@linux.dev, muchun.song@linux.dev, qi.zheng@linux.dev,
 yosry.ahmed@linux.dev, ziy@nvidia.com, liam@infradead.org,
 usama.arif@linux.dev, kas@kernel.org, vbabka@kernel.org, ryncsn@gmail.com,
 zaslonko@linux.ibm.com, gor@linux.ibm.com, baolin.wang@linux.alibaba.com,
 baohua@kernel.org, dev.jain@arm.com, npache@redhat.com,
 ryan.roberts@arm.com, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260527204757.2544958-10-hannes@cmpxchg.org>
 <20260601103947.63923-1-lance.yang@linux.dev>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260601103947.63923-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 9yi3mtjmshkzjmnsorp8raz1ntjzod3c
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 73C6A4000A
X-Rspam-User: 
X-HE-Tag: 1780312191-125926
X-HE-Meta: U2FsdGVkX18cpzxmWxm7vuRxd4WJ+pFyFRNaQKlPYRKCt/5PWbb/gREfKwKXnZDN4kIHO7sR9WNHeWh73/cT3UNIecu96JkuIuqfzwrUo/JAyzKU3h1hmSdDU01ygI3x04kSVAE4p+cJuJAc+S7sQSMMKjV8i8QD675XwlEoAUZwQru0qwuwm5XorOS4KD7AFKoH3WUsCImUDds9vNYKcgBfgT1viyzd60ygRJXCSyrASbC4rm7Gl46SvbkBQNmd+TCiZb2H5hhBUYBjnsnYvpQ7/fqfRlUF0jA24l6cIFLh3tSb5NWpEOXoF0t9UKGjY4pajmixe6BI/9MpnzUgqFxUW3XjqCbxY52AtY/hhFBr+wEdCrI6az8vu36oNGZaYMBIZKwQOVaYj9zCGjAzqaa5utoNjLAYEuV/gLlCXTgFRbVc6pTYx45SFVFvg/kpPVriEyxpyth0tUcDqiwayRuGzNVkG3MzCGqKASjEGUxB1gqw18/cBq6uwoF9cG3a8MbrKEpk05pqGni9J/bie5Um5TK+PONy+5TqMJ3yOgx9M+qzls7Q+VfexwLL2zgwmWY5YNvGfukrQi+VwaE/MzSUhFadjXT2u/gTLx/3jgAramarQKdWgtjbUAC5EOAxq6k/+fFgq9pI7daGKX/nFZPQU7nvdIXFWFcaQf+vq8CqQp2WpCHgOZH0GNzwIUuiu5JtZ205utoNGS+kAAsj3M5VZnftbJobhR53bKcVpte4+ZlnSPEusEgJQNuSWhNISaSRbb0a9cvtuhZXGX+CdpI69Ji8Gw7jxkxYLScZNmneUjPSjfU1VwMgvpMBwi3yfw3zGsZa3bsk2MZzE3Jy/toB1hPwEgpYi57YMWJATGTV9xHkNHonJU4QvLUVvtFBUxu0B5k8N2ka4QH8/red4zwvOVE7I5YBw3c5R2NYzrgKVN1J7Y0q6PHHidHds9myIJhtLZPZgyTHKNm/cGX
 T6Em730c
 AhgRkcwIqzPMR8S7qy/NNvz0PBYdkAK3NV6BdBXnMgWDeRT8wj4bBEwWT+/b2qjpLTgW1fBU/VpYt9UJqcAQjvZl7vinGbVPH/ij/gXbM2W/fS6UHbfVs6JdmRSYhKLZh8t8tavBMTBnflJS7kvxgQ7dRZqjO2HIi1mNKuX8fnKGP62s+CMaeOAV53C1vSaCIQ4GUaBOJ3+qdWzzZDUw3coq57rWke7Fc6jiqRf4koSLJEOFVN3VR9B3U6mwdhlRjIATNko5tFzfRKBSNffjHSoWdvnRT+c68UTXu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/6/1 18:39, Lance Yang wrote:
> 
> On Wed, May 27, 2026 at 04:45:16PM -0400, Johannes Weiner wrote:
> [...]
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 135f5c0f57bd..f22e61d8c8de 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -5222,6 +5222,10 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>> 			folio_put(folio);
>> 			goto next;
>> 		}
>> +		if (order > 1 && folio_memcg_alloc_deferred(folio)) {
>> +			folio_put(folio);
> 
> Missing a MTHP_STAT_ANON_FAULT_FALLBACK bump here?
> 
> Since we jump straight to fallback and end up at order-0 :)

Sorry for the noise, I missed the earlier discussion. Never mind this 
one, please.

> 
>> +			goto fallback;
>> +		}
>> 		folio_throttle_swaprate(folio, gfp);
>> 		/*
>> 		 * When a folio is not zeroed during allocation
> [...]
> 
> Cheers, Lance


