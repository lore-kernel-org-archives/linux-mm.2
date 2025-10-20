Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12567CCD193
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 09:08:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694C18E0011; Mon, 20 Oct 2025 05:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C818E0002; Mon, 20 Oct 2025 05:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 582818E0011; Mon, 20 Oct 2025 05:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 46E638E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 05:08:35 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E64401A07C7
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:08:34 +0000 (UTC)
X-FDA: 84017916948.20.4C88B69
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 324FA40005
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 09:08:32 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n3exHA1N;
	spf=pass (imf17.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760951313;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y+bASNQUkUwvoZDfoRWKEEvyzQN9SFzG1qIKkEwliH0=;
	b=JEg6DppHVVNmqgkz1Rd8hJN7kDtXB3ddqTaRf+enRyQPji040vefSgew35CuWtQXtrVWkb
	OBGkqzZLzVoAy7wzzre8tG7pAcntWOWE/5dyZ1OEkfdc2/flud35jGINDLJS51+vrGpd+M
	gwb4563sY+vZS/yi9U2GlOYoit2+dKM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n3exHA1N;
	spf=pass (imf17.hostedemail.com: domain of jirislaby@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=jirislaby@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760951313; a=rsa-sha256;
	cv=none;
	b=EuFFtagXCWJ8jjli/LdkY9jxbHUhz7xNR711g4V99+9d7pjZ0liNyaUYtsOU16N67dxn1r
	6P8CDq0ENCH5aZdvYTtK7RY/SQxApW7LBqqInk6TW4stD71qoJkqH2VA4LwC4l1FJGACCc
	Tfpa7RYARhXw6X6cajAcT+vcFYywy2Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2B344448AA;
	Mon, 20 Oct 2025 09:08:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E19FEC4CEF9;
	Mon, 20 Oct 2025 09:08:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760951312;
	bh=TOEucrKhh9Ci7uSuIVms25ipmDEQw2ymMffw7zJm9Ck=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=n3exHA1NzTdGYdpT2XXmKdsmsnrI9co8rqalqSOTBtXpHEOb39N2D1UH29QN4og3c
	 pDvnNPfcApPyRzGmN+FEURJak22Md15XOPS36NQSp6oQ/rlq0f5F//2NYy3XFscBfl
	 kxk0j5Y8QO9J1GL8T40gMKafjVrOABQamTf9ZCzhUzSAHrD+jsCEA+QaM968jF8fF4
	 dYzdtnwIONDuF9sT5SEMtkIb5ElfXVLV0XDcjjZ0d0Ajxjje8Y15exD6a3sTds4wua
	 MxlPDr2KGoKiwbTOKDR52zH825vm7zxMoGXLqsll4v2Rke2H4UWjZqGaZL2kXR/uQK
	 IxQIrc+2yzjNw==
Message-ID: <3b97b754-890a-46c6-b892-a0324d529a3d@kernel.org>
Date: Mon, 20 Oct 2025 11:08:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/3] mm: treewide: make get_free_pages() and return void *
To: David Hildenbrand <david@redhat.com>, Matthew Wilcox
 <willy@infradead.org>, Mike Rapoport <rppt@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Brendan Jackman <jackmanb@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Julia Lawall <Julia.Lawall@inria.fr>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Michal Hocko
 <mhocko@suse.com>, Suren Baghdasaryan <surenb@google.com>,
 Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251018093002.3660549-1-rppt@kernel.org>
 <aPQxN7-FeFB6vTuv@casper.infradead.org>
 <3e798b9e-4915-404f-9197-ed3c32587141@kernel.org>
 <85707316-3f2b-4e29-b821-a32f9097244e@kernel.org>
 <635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 xsFNBE6S54YBEACzzjLwDUbU5elY4GTg/NdotjA0jyyJtYI86wdKraekbNE0bC4zV+ryvH4j
 rrcDwGs6tFVrAHvdHeIdI07s1iIx5R/ndcHwt4fvI8CL5PzPmn5J+h0WERR5rFprRh6axhOk
 rSD5CwQl19fm4AJCS6A9GJtOoiLpWn2/IbogPc71jQVrupZYYx51rAaHZ0D2KYK/uhfc6neJ
 i0WqPlbtIlIrpvWxckucNu6ZwXjFY0f3qIRg3Vqh5QxPkojGsq9tXVFVLEkSVz6FoqCHrUTx
 wr+aw6qqQVgvT/McQtsI0S66uIkQjzPUrgAEtWUv76rM4ekqL9stHyvTGw0Fjsualwb0Gwdx
 ReTZzMgheAyoy/umIOKrSEpWouVoBt5FFSZUyjuDdlPPYyPav+hpI6ggmCTld3u2hyiHji2H
 cDpcLM2LMhlHBipu80s9anNeZhCANDhbC5E+NZmuwgzHBcan8WC7xsPXPaiZSIm7TKaVoOcL
 9tE5aN3jQmIlrT7ZUX52Ff/hSdx/JKDP3YMNtt4B0cH6ejIjtqTd+Ge8sSttsnNM0CQUkXps
 w98jwz+Lxw/bKMr3NSnnFpUZaxwji3BC9vYyxKMAwNelBCHEgS/OAa3EJoTfuYOK6wT6nadm
 YqYjwYbZE5V/SwzMbpWu7Jwlvuwyfo5mh7w5iMfnZE+vHFwp/wARAQABzSFKaXJpIFNsYWJ5
 IDxqaXJpc2xhYnlAa2VybmVsLm9yZz7CwXcEEwEIACEFAlW3RUwCGwMFCwkIBwIGFQgJCgsC
 BBYCAwECHgECF4AACgkQvSWxBAa0cEnVTg//TQpdIAr8Tn0VAeUjdVIH9XCFw+cPSU+zMSCH
 eCZoA/N6gitEcnvHoFVVM7b3hK2HgoFUNbmYC0RdcSc80pOF5gCnACSP9XWHGWzeKCARRcQR
 4s5YD8I4VV5hqXcKo2DFAtIOVbHDW+0okOzcecdasCakUTr7s2fXz97uuoc2gIBB7bmHUGAH
 XQXHvdnCLjDjR+eJN+zrtbqZKYSfj89s/ZHn5Slug6w8qOPT1sVNGG+eWPlc5s7XYhT9z66E
 l5C0rG35JE4PhC+tl7BaE5IwjJlBMHf/cMJxNHAYoQ1hWQCKOfMDQ6bsEr++kGUCbHkrEFwD
 UVA72iLnnnlZCMevwE4hc0zVhseWhPc/KMYObU1sDGqaCesRLkE3tiE7X2cikmj/qH0CoMWe
 gjnwnQ2qVJcaPSzJ4QITvchEQ+tbuVAyvn9H+9MkdT7b7b2OaqYsUP8rn/2k1Td5zknUz7iF
 oJ0Z9wPTl6tDfF8phaMIPISYrhceVOIoL+rWfaikhBulZTIT5ihieY9nQOw6vhOfWkYvv0Dl
 o4GRnb2ybPQpfEs7WtetOsUgiUbfljTgILFw3CsPW8JESOGQc0Pv8ieznIighqPPFz9g+zSu
 Ss/rpcsqag5n9rQp/H3WW5zKUpeYcKGaPDp/vSUovMcjp8USIhzBBrmI7UWAtuedG9prjqfO
 wU0ETpLnhgEQAM+cDWLL+Wvc9cLhA2OXZ/gMmu7NbYKjfth1UyOuBd5emIO+d4RfFM02XFTI
 t4MxwhAryhsKQQcA4iQNldkbyeviYrPKWjLTjRXT5cD2lpWzr+Jx7mX7InV5JOz1Qq+P+nJW
 YIBjUKhI03ux89p58CYil24Zpyn2F5cX7U+inY8lJIBwLPBnc9Z0An/DVnUOD+0wIcYVnZAK
 DiIXODkGqTg3fhZwbbi+KAhtHPFM2fGw2VTUf62IHzV+eBSnamzPOBc1XsJYKRo3FHNeLuS8
 f4wUe7bWb9O66PPFK/RkeqNX6akkFBf9VfrZ1rTEKAyJ2uqf1EI1olYnENk4+00IBa+BavGQ
 8UW9dGW3nbPrfuOV5UUvbnsSQwj67pSdrBQqilr5N/5H9z7VCDQ0dhuJNtvDSlTf2iUFBqgk
 3smln31PUYiVPrMP0V4ja0i9qtO/TB01rTfTyXTRtqz53qO5dGsYiliJO5aUmh8swVpotgK4
 /57h3zGsaXO9PGgnnAdqeKVITaFTLY1ISg+Ptb4KoliiOjrBMmQUSJVtkUXMrCMCeuPDGHo7
 39Xc75lcHlGuM3yEB//htKjyprbLeLf1y4xPyTeeF5zg/0ztRZNKZicgEmxyUNBHHnBKHQxz
 1j+mzH0HjZZtXjGu2KLJ18G07q0fpz2ZPk2D53Ww39VNI/J9ABEBAAHCwV8EGAECAAkFAk6S
 54YCGwwACgkQvSWxBAa0cEk3tRAAgO+DFpbyIa4RlnfpcW17AfnpZi9VR5+zr496n2jH/1ld
 wRO/S+QNSA8qdABqMb9WI4BNaoANgcg0AS429Mq0taaWKkAjkkGAT7mD1Q5PiLr06Y/+Kzdr
 90eUVneqM2TUQQbK+Kh7JwmGVrRGNqQrDk+gRNvKnGwFNeTkTKtJ0P8jYd7P1gZb9Fwj9YLx
 jhn/sVIhNmEBLBoI7PL+9fbILqJPHgAwW35rpnq4f/EYTykbk1sa13Tav6btJ+4QOgbcezWI
 wZ5w/JVfEJW9JXp3BFAVzRQ5nVrrLDAJZ8Y5ioWcm99JtSIIxXxt9FJaGc1Bgsi5K/+dyTKL
 wLMJgiBzbVx8G+fCJJ9YtlNOPWhbKPlrQ8+AY52Aagi9WNhe6XfJdh5g6ptiOILm330mkR4g
 W6nEgZVyIyTq3ekOuruftWL99qpP5zi+eNrMmLRQx9iecDNgFr342R9bTDlb1TLuRb+/tJ98
 f/bIWIr0cqQmqQ33FgRhrG1+Xml6UXyJ2jExmlO8JljuOGeXYh6ZkIEyzqzffzBLXZCujlYQ
 DFXpyMNVJ2ZwPmX2mWEoYuaBU0JN7wM+/zWgOf2zRwhEuD3A2cO2PxoiIfyUEfB9SSmffaK/
 S4xXoB6wvGENZ85Hg37C7WDNdaAt6Xh2uQIly5grkgvWppkNy4ZHxE+jeNsU7tg=
In-Reply-To: <635405e4-9423-4a25-a6e7-e03c8ea0bcbe@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: acd1m6z19a7bntgmhsix4dr5kiz98akt
X-Rspamd-Queue-Id: 324FA40005
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760951312-561869
X-HE-Meta: U2FsdGVkX18NuKWGOSLfiOE6psbNjXp+vhoVZsXlSQnVSQ9hN8mRG2g3+M1XP2tIXeU7pBPT6nEpV+TQQ1uFzlx09hPxJfHIEbOTyMoLMe46tFwP2orF4kf8rmDHyWQ0rc7vEfOYwCbbZm5iYVR1dKNX8wpTDPz65V4taVeytlYRMVZfAQWmO9lzFcOVJHHF+4KhiEouSottA8GLphTCP29/ybjAVEsAM5uoy6FvHhVxxoTROcWyXPRdXyKFaMp+QiI5zj0EX0v8YuYYes+H+F5qDWoZhY5M1C4kOEglf2PKDoXNvz8mIIZ9kIJM8WUbzBoKA0vZG9LeKDYcGHZe9owW8tZeRnebxriAIFW5sZ74EEpf14AwR9b7bM/tuWN0Vdvhj0THQUJCfTnTkWOCnko6f+Uk7QzeKJ5S/4l+oSpZgpeyp/t1uH0aqk9pwyR+vI3g9qE0FcBFZscyJgURBTZsHFyspphJi8DjT4FhCQugfdobrs0KPXl9FhzFsNCmfRgepvbLoBXHmwDY3lZSrx+rXVIUulV8TyEEbV4Tz9929UdFScj4ka7zmrBWEk039/iJ0tADjVGAWwxmspVn+Ua4SsCbn8d0zMG349XnzajJr8+L+rTB1DplpGyIPWs06T8xWeVhq4ql4l8TXaMyreb0HnTaz2ZAPWNyT9EQIYi3mGEe0H2KLAVe1MF5egJAw2vbJ32nyuWHNB+hkD9Oi8Ynw8vszigFD9wu8GtGZoIok28HdjK/N/BXOi2uqgPrg7KQI05xDiJ2/XSNf5PHTidVBEwCudtg7RXk5yBZWgwrQVOmYaqjpCyaSgN+oDk3gPh5u7biVvFmJVkqo6NXJ/faQjMtFgaSF/uQpuFRNBeFtC+MkUlpXM91EAEX84NFUuhyT85Kl4ulPXkcpQkRXsGixc8+8B+8eystMFA/AfGNPLABVSmAKBF26j7p7Epr7ExPdQGTzmBh8xaI2Od
 MvcvuFeJ
 /7mNUIJ+FH5FWAEs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 20. 10. 25, 11:02, David Hildenbrand wrote:
> Regarding the metadata overhead, in 2015 Linus wrote in that thread:
> 
> "Long ago, allocating a page using kmalloc() was a bad idea, because
> there was overhead for it in the allocation and the code.
> 
> These days, kmalloc() not only doesn't have the allocation overhead,
> but may actually scale better too, thanks to percpu caches etc."
> 
> What's that status of that 10 years later?

AFAI skimmed through the code, for allocations > 2 pages 
(KMALLOC_MAX_CACHE_SIZE) -- if size is a constant -- slub resorts to 
alloc_pages().

For smaller ones (1 and 2 pages), there is a very little overhead in 
struct slab -- mm people, please correct me if I am wrong.

thanks,
-- 
js
suse labs

