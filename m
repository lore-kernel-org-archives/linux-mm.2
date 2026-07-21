Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4A1FC44529
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 14:43:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D801D6B00B5; Tue, 21 Jul 2026 10:43:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D31836B00B9; Tue, 21 Jul 2026 10:43:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6E306B00BA; Tue, 21 Jul 2026 10:43:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 98E9A6B00B5
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 10:43:42 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1EBB8160174
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:43:42 +0000 (UTC)
X-FDA: 85013052684.16.E2390AA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 6CBE480012
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 14:43:40 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+e9OZZi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784645020;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=olLhFfLQoyr4q/gUUxf2G5MJgNcHZvq8RkoA1mPtdUY=;
	b=z5PKaLu6Tbq99PuuW8JV8lClyvFkDJiTkP04mJ5DYky9RNrngGH+ZARPdwp8Yhwms68Qbq
	pHKJgWLMg1GvCS3RKPbI5dtUkOoaHriHCUoum/+6dOX5xZ/wB/NkwiK4SFPY81htaHkuxH
	ei5KDSANR+RfKK1XYEO+zi4dG3yzPMU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+e9OZZi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf02.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784645020;
	b=OKhFWmzcx3aQkarJDDLA1b1DrNZPUpxzkzmbZRcapHb77piZBb0wgKUoVjJkd8hM/QcEPN
	o/k+al7P5NJVfC1XMSxVCXYKR1xl7h6M7Pvrnc46jlEWJOZ6MsCKAzBajg696PtFkx9Gje
	GKvqmcfYnWb9wRf7AS8vSBvf3Dgb5So=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A439160054;
	Tue, 21 Jul 2026 14:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F371F000E9;
	Tue, 21 Jul 2026 14:43:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784645019;
	bh=olLhFfLQoyr4q/gUUxf2G5MJgNcHZvq8RkoA1mPtdUY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n+e9OZZi58BM08zRIJazklblOQRdvuRQmcPvTPji+ceOCw/wzktUOqjA2Q65Gw70X
	 bsUf1aBB4De3Ntgx0D3QASJsT42BFhTZYhhTYAGtdEEC2QdhESo8sZ6Fpm2SAfYy1k
	 KtlEJ0GgZNBq5b2C59FuxEenLWQ/ek5VmtjNAZHksSqwbvOrhMR/jqi6p3BaIAsYwR
	 s6aBg7mDXw2uwfsKowcYq/LXgYDAjln2l9ITibmiQcmOrL5q70+XBgmqGvPygeuPgM
	 H7W6KhllzepBnsFXaqM5i6VyTct2Y79mu+KAh3aK63fjTI2rOFv83Klbb3myV/bZ3x
	 glc8aE/vZPi7A==
Message-ID: <348dcc9c-00bc-4b59-a266-4f11bd2990e0@kernel.org>
Date: Tue, 21 Jul 2026 16:43:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/slub: prevent pfmemalloc objects from entering the
 barn
Content-Language: en-US
To: Harry Yoo <harry@kernel.org>, hu.shengming@zte.com.cn
Cc: akpm@linux-foundation.org, hao.li@linux.dev, cl@gentwo.org,
 rientjes@google.com, roman.gushchin@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, zhang.run@zte.com.cn, cai.qu@zte.com.cn
References: <20260721171753509I9L8xNy2kiOGQFKloTnrG@zte.com.cn>
 <85ddd27a-ade6-4f27-80ab-cb91caa4e171@kernel.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <85ddd27a-ade6-4f27-80ab-cb91caa4e171@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6CBE480012
X-Rspam-User: 
X-Stat-Signature: z1gj6g1jdrkiwmz9njf6gm7cfxzdahpm
X-HE-Tag: 1784645020-323108
X-HE-Meta: U2FsdGVkX18rQtDaPFqahWABh3ANt0PbmmYI3+OxdyfaW3vy8rvwWQLEb077RBBuoPeYtAvtb8zejBtEkwftwoq7xJ8SvxElacAzQa4y2BVPfC/jmfT2eZijWFFxwiLop0Es0pCEL/9je33uGfhA7zkvzk1Iz3tYVsSckrNQuO4UTzTbnWVSV49wAGJPrv1TvvSTlIYZxt8J369hnH5Ss+VcZ1VnmYse+z0j4wFHVHJFSLa7bBSGukjRf/O8OsYB+r/Ejjmh/ptAd8NQkTQ4//S/O0W6tvlzYbIPix8VWTCItTRZLuaZM20d+7sFkIy+g3tO+j0Qb9IJappEfg8gTueylCDBQg1NVSkLgNKd/O/jYoPBPUrgpck5na3AuN9TgDPewyoWHvMfEzayxAYbbxF2X3sOsjxBXoPay/5U9uxkqehEjPjCUbBFouUJFyaYXqd99dhyl0JkTWuKzdGqQOPW6BBfFCbL1RAOOQslNl+pxGZfTbSMf3QXg/x2S/ZXM4Ikse7NRhRQvalG5BTmPikA8+FbP8R+WCNCAJ4Wfg3M7arrKAH5OPzSY59IU+m2mBLfO6Lu6KmQ5judM06VmFWba9VzpwIbXvN5saQYOW6B4vAjr4iEMY4IpUWoMgXSSarxHeCBB55PZy0Lff++L7PNgs8WuSypEfuZgIgpR8U5orccZ4Mjn+93IqnBud35q2F0mouKYBIpgc60yvn4WUk6dCUAY9UkvwGxGDkisvbJrPMLCZXPGNRYZnsBLtq588+TpC0JdGJQbmPrMcr9tgHewkWbQjza7NZmxxYBsupAPLqH6DKfmqrNijB2JApHj13umRbLQ4fk1BnoaIRc2G1XQ42ehjSDlPGVO79mcKaKEENauFr8WTFhhwA/+yOUWcp8MN8aqSsRb9xcu9Q0d4TNFDvpIIzA28zOiwlIOHc1Aa99OSrF3/vNMYE2TCgNu0yTNRZKhZiySRDwmvn
 zEihFsXa
 bJCdZiAvvfmBSLsKLRAKncu//b8FXwX4J/YWk862TOXz2bw5y93WhAzzlwvNMB4+26MN4qytcyDSQQyybdIzWKAVEUAnOo61+ZNbsg+xTqVnRsNzmYtzQwNHUgUuTmEm7DV5xzrZ20Ava8p4zxGQmeje0pHffXxOFYgoPwYhdJ+ftgykYVQHh6zTul4jVHgo0JYWg7JxJqQGShLi9cFHcnIGc1agZovbaKqRvltTjEWdLNObE9k1WSeKC7tM9nZfUdSzAVgY978b9N2OALuvPzVBkvboNWE4d0bLOUada0JMswFnUQXAjLGTI8/2G2w8t2VOdxZpdtNUcMHMpxBrds/AnxCvej6zdn0dpc9JWQi0BFEjmAnUFzLp0+2Y3CrQ+wr33DSPMl1DNDLc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/21/26 16:27, Harry Yoo wrote:
> On 7/21/26 6:17 PM, hu.shengming@zte.com.cn wrote:
>> Vlastimil wrote:
>>> On 7/21/26 02:45, hu.shengming@zte.com.cn wrote:
>>>> From: Shengming Hu <hu.shengming@zte.com.cn>
>>>>
>>>> kmem_cache_return_sheaf() may refill a partially consumed sheaf before
>>>> placing it in the barn. Without an explicit restriction, this refill may
>>>> draw objects from pfmemalloc slabs and consume emergency reserves.
>>>>
>>>> Add __GFP_NOMEMALLOC so that returned sheaves are refilled only from
>>>> non-pfmemalloc slabs. Also add __GFP_NOWARN, as suggested by Hao Li,
>>>> because this refill is a best-effort attempt and failure is acceptable.
>>>> If the refill fails, flush and free the sheaf instead.
>>>>
>>>> Fixes: 3c1ea5c5019f ("slab: sheaf prefilling for guaranteed allocations")
>>>> Cc: stable@vger.kernel.org
>>>> Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
>>>
>>> Ah so per sashiko [1] we should consider adding also a __GFP_NORETRY to
>>> avoid an OOM kill. Seems reasonable that an API for returning memory should
>>> not cause an OOM kill... it's unusual enough that it takes gfp flags
> 
> Ideally the caller should not specify gfp flags that could invoke
> OOMs.... but even GFP_KERNEL for non-costly order could invoke them.
> 
>> but I
>> thought defaulting to GFP_NOWAIT would be an unnecessary limitation.
> 
> I think it's reasonable to drop gfp parameter and default to GFP_NOWAIT
> rather than relying on the callers to avoid OOMs or implicitly
> overriding the behavior.
> 
> It wouldn't be too limiting given that it's for returning memory (!) and
> other free APIs don't take GFP flags and assume GFP_NOWAIT e.g.) when
> allocating a new sheaf.

Indeed, let's do that as a separate cleanup.

>> I can add __GFP_NORETRY locally if others agree.
>>
>>> [1]
>>> https://sashiko.dev/#/patchset/20260721084522552ZPa16p1SRj3PYat3sqxuN%40zte.com.cn
>> 
>> Agreed, adding __GFP_NORETRY seems reasonable, since this best-effort
>> refill should not trigger the OOM killer.
>> 
>> However, I wonder whether the same scope consideration that Harry raised
>> for __GFP_NOFAIL also applies here, and whether __GFP_NORETRY should be
>> discussed separately rather than folded into this pfmemalloc fix.
> 
> Agreed that this is an independent issue.

Yeah I won't add __GFP_NORETRY to this patch.

Thanks!

>> The earlier discussion is here:
>> 
>> [2]
>> https://lore.kernel.org/linux-mm/33a1cb67-8d23-4b51-b4d8-9e95e8de00c7@kernel.org/
>> 
>> --
>> With Best Regards,
>> Shengming
> 


