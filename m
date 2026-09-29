Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E6FAC9832A
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 07:16:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38B9C6B0092; Tue, 29 Sep 2026 03:16:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 33CA36B0093; Tue, 29 Sep 2026 03:16:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22BC56B0095; Tue, 29 Sep 2026 03:16:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 00E9A6B0092
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 03:16:45 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8D1D5A0419
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:16:45 +0000 (UTC)
X-FDA: 85265942370.01.9E63A43
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id D9AEE1A0003
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 07:16:43 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPvIhzZV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790666203;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lAgsxeuo1uwHONfqh8pxHditw8tVE9dP/mYZuc/xVh8=;
	b=2sPnJhtaoTW550G9DXgBRhVm4idiy/pyJWnF0xxC2FMCNAbbcnCrLf/DQ8T8PTTBJKzWk6
	ypHlcR8UxSMVTJMBjO0KHPWQJFQ120dX5w9J5++yH8fTnnTuVcf/um1e3uLUMwzca62/0Z
	tzewse4CBkQm6Vj7/x0W6KH4ZrShIVk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XPvIhzZV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790666203;
	b=T8pn1rE845FllyMgAoRwlwCG6aoZH7rTDhQo1Ei4qu3lB02y+7T+0bzLe+VbShJ7QF//Dv
	asBw5m52eLlDRParNwQbd1FiJ0nxzI+ocXgqz9SuR2ic0m8d25IeOzu2QqVg/+Ku/rO80+
	dH0ZM4N5x7zX/w8Bc8jD1gGNmu2wMhc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 312A260A59;
	Tue, 29 Sep 2026 07:16:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95BBB1F00898;
	Tue, 29 Sep 2026 07:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790666202;
	bh=lAgsxeuo1uwHONfqh8pxHditw8tVE9dP/mYZuc/xVh8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=XPvIhzZVscw0/cIG0nNlyQJokQTnSAf2sVHgbX/GtyrbGyCa9VYZCF03+80v4yyBe
	 T6BnIW4SEgx/0905eYA6L0YqyQfMPD4ZxPieJLrEijDAEAK1QXGh2PQodJ2iPg7ip+
	 bsF4tNu9o+DEnz08puq3XIu8kQWM8gWwa7fBeI3tUGiSs7JNuq0lfJ+Rkk2sqFpf2e
	 2i0w1njrIONG0cBXMFQbOWvlDJiCkgblfTEAQyKEIBYTNyIqkx2fZGFwsaSuNM73Rk
	 22v9ZCodwNJwGKjsqEBxrY8hP38UnJAbvN/N1sdidyje7sTphU6cS6JCCQWoO4USUA
	 LqQKah1HtBqBw==
Message-ID: <5c73e3b9-4eca-4b84-ba3d-85bb7d6f77dc@kernel.org>
Date: Tue, 29 Sep 2026 09:16:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 01/12] mm/sparse-vmemmap: factor out shared vmemmap
 tail page allocation
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador
 <osalvador@suse.de>, Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Jonathan Corbet <corbet@lwn.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, linux-doc@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 Randy Dunlap <rdunlap@infradead.org>, Lance Yang <lance.yang@linux.dev>
References: <20260927025441.741633-1-songmuchun@bytedance.com>
 <20260927025441.741633-2-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260927025441.741633-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: D9AEE1A0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: bhy1kr8bh8m6qbfuhtaro1ky9cugaa1b
X-HE-Tag: 1790666203-592943
X-HE-Meta: U2FsdGVkX19h/qtWI9GziQryi4Z+mSQdJdqxduU+V+hBnGQyAnGIKRsAP3RH/FywgGdphcaJCcrttXysezjdnTO+8usXv/b8BuC0obQ1QD1KEt8P6OdzFwuNppZItMhjMmiZh6bT5FN2AWFaVZRi9wT+bqksVUIqJ0DLUf/IlCf1UbYMhATdI49umEyaBTmVYJM3Jjgi5UGBEzUfivD0lP/fUda1DUR5EYP1KFOFNUkIWZobtTf11LwB7fTKsSVQSplfQcDCxRaNCfBCcodG84xFKLNi3HHLgAd+4DzCBEwBIYTmzWMydnU+KvQBkhNRTG9w3q+ZK8Ah0L9/LsA5kpdrsremnoagI8rIq6QjjZQUzZP4BlqUlc9RlghOXNVf/8wluEulHloTDJil7VZ3QGXoqgC+ve72NRwFFky3PqI6CaAxWsKjc0nsDEhew7s3vCezG1/lO57HIQNKhJvfFreZYgwTup/iUBXPO/0mGfygISxmqjSkV8InG6x4lJii0Bx9/6X2wrVw5ppD5NrWQSD4/ElEoo6P8duCx1kXXxZK5JRYxDKVCU5hm++vpc0DUffiEE1g0oHZ3wnNdoz1jA2wTMKbQDHk02ti/OF2Z7eIi6+ffkiTcI4VdNmuloglEQftGNX/MbgsKrDpPzqFvvSZ59keVqQWpSdwqokcatRt6DNuHueh14Iro/z/GCzATX0qLQVjgTJR7Xs4n0mkXw2I2651BP3ygfSLYVG1afemk8pK7KVa3m/uOidtS7zaKMC6foW+hI1CZLVrMoxluZod0H1IrehqudMilce+fNeW8Z7FSCyAnTeMy7qQQkTcifCcngAkHBh1JCI7Ar/csytVWXKeeaQacKKOvWSLme14wkmVSumYioagTc9lYUxBr7VtiatRzGVS1KwJQJaLGOj6cdIICXSCavhDbqAJR+yPORCtQIvmIYii2NSQxoD/fI91f2fEV3htQO2WBfi
 r1nUR8TQ
 xpq9JbbuolDNYjmoWywqn/YaPke4ekaTqyYla63pUzE4LlsLcv8xsCQ6mdMZb/zmsE6FaTWVJOjXjYyZrbpnJeVJjFfMTRMSsK49/sp34yUk78FqlynPJ5Vum95ixCJygCU/UpAUuFnhMRKcDv16CdzPEiXuUg/CIrmjWSLdJND6ammSp8h3ONfbkvKV6Imx4Mtdle9FFUVp07+3E0wIl4YkZ9ty4iEBhnWM9Zg5dc0sLukzupTTMTEQ93wMrH5BitJIMnRMXC4kJ9f7PoymfDXUiPS8udc25CyXv+xu41g4IfYbSyNB6hX0wRA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/27/26 04:54, Muchun Song wrote:
> HugeTLB and sparse-vmemmap each have their own helper to allocate the
> shared vmemmap tail page used by vmemmap optimization.
> 
> Factor that logic into a common vmemmap_shared_tail_page() helper. It
> allocates the page through vmemmap_alloc_block(), initializes the tail
> struct pages, and uses cmpxchg() to install the per-zone shared page.
> 
> This removes duplicate allocation logic while handling both early boot
> and runtime allocation through the same helper.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Qi Zheng <qi.zheng@linux.dev>
> Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v5:
> - Move this patch before CONFIG_VMEMMAP_OPTIMIZATION is introduced
> 
> v4:
> - Update the commit message for the renamed VMEMMAP_OPTIMIZATION config
> - Collect Acked-by from Mike Rapoport
> 
> v2:
> - Collect Acked-by from Qi Zheng
> ---

[...]

>  
>  #ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> -static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *zone)
> +struct page __ref *vmemmap_shared_tail_page(unsigned int order, struct zone *zone)
>  {
> -	struct page *p, *tail;
> -	unsigned int idx;
> -	int node = zone_to_nid(zone);
> +	void *addr;
> +	struct page *page;
> +	const unsigned int idx = order - VMEMMAP_OPTIMIZATION_MIN_ORDER;

Nit: constants read much nicer all the way at the top.


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

