Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DE93D1F9D5
	for <linux-mm@archiver.kernel.org>; Thu,  4 Dec 2025 12:42:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C11E6B000D; Thu,  4 Dec 2025 07:42:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998D96B0010; Thu,  4 Dec 2025 07:42:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D5AC6B002D; Thu,  4 Dec 2025 07:42:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 80B8D6B000D
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 07:42:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38EF614013B
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:42:27 +0000 (UTC)
X-FDA: 84181751934.22.7A2E353
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7EB171A000E
	for <linux-mm@kvack.org>; Thu,  4 Dec 2025 12:42:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=brJP1+z2;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764852145;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=06vN+NQZapDoZdJH0W7ZXKrqsn8wKKoOS1eC5r2tWnE=;
	b=VV1rITHNhyUqR+5d1HvJxy6CivrTgbatRShSWpv6vj0FlETJxz4x2oQl9Pbf6nUuqjINwA
	4nh05JRc5nYOlviVr9K9lcbaxiwBvfW/FAUOgtZ/L/MgdC4/gLSNBvVXUz9og770kymshV
	MGA/IuBFn+Q5+xRgdBVgzMSaVuceCLQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764852145; a=rsa-sha256;
	cv=none;
	b=R8TtCeIKK02qAJVQsJF8PD9OWO09dk31rkSr96MxPoP2gzgSh/0eSbzzylB0lElb+pbBz5
	4GcNEKEOJO4ib+QdyZif1l6N5NhttVB3ssCoxV/0i1UlCQWcKQr1uOP/ujMQtcr3Jfy9eJ
	cvg2CrWZkTDCSyrN7EH+e0q3MLtxzf0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=brJP1+z2;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A12FD601E3;
	Thu,  4 Dec 2025 12:42:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B35E5C4CEFB;
	Thu,  4 Dec 2025 12:42:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764852144;
	bh=8IEFSuSrYHqIBmea/jkeB6Aa+5WiQ6kLiFusAPNBjhs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=brJP1+z26wVKIZMVtWGv/VObdgbyW/nl5Ryl8E1JWdUv+s2XaZjH/yZxbMdIkpAE/
	 vExncNyidXnpQz5I4ou62AkWSsUcC5ChMDID0fXSk91IYIVfhwaE6Vp6viAt14EWYH
	 fP0o1P1rhEZDV4eSUcYD0p5s0zT7Q/4IC8C761st0z7Ybc9HIszJuIjNvH04cCoCJp
	 IfymBV1DwHyojOEaHlFGZ2inIDBlbqyv+KvnkQAbj5zCS2BQI2T3/sqwGUEEZkzgeV
	 ceRTeF/+edGXHQP7zqyQ93mpQmtIidZwJWsH4RwraNfpz5vjq6F2k7+RnWvbaJBmmZ
	 lR0n580s61n0g==
Message-ID: <308c809e-160a-4829-a8b9-9c7682fcd251@kernel.org>
Date: Thu, 4 Dec 2025 13:42:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v2] mm: vmscan: correct nr_requested tracing in
 scan_folios
To: Chen Ridong <chenridong@huaweicloud.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, yuzhao@google.com,
 jaewon31.kim@samsung.com, ioworker0@gmail.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251204122355.1822919-1-chenridong@huaweicloud.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251204122355.1822919-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7EB171A000E
X-Stat-Signature: n4765exbq1c4hhehw8a8yosigecypu6r
X-Rspam-User: 
X-HE-Tag: 1764852145-122954
X-HE-Meta: U2FsdGVkX1/x6fOxgx2Goc5sKxphbxkZP2W0rqFwn/Im6GAR2JU0RzRtnG2G78EWxQ9iaAeYpa7ziv7ki8yP47OqEyfaq73DPtkAKy8t2zt69b4IiRwUWWdMUWlfdONRCD0j55ZJJCDqO1p5CvcNT8+xB03voycF3Wj+v8NKOcSAH4a53Mu3jZYgXRquO2B+0zp95/kI2aq5fZZqdkzPoj7cO55l+lq0HtD1r8dlii9u0c7U7qugjitpBFn5vIKCQ3Fu6vSwq5DzI0yD0mUHp01ukY7DmEk/ctEsJ79x5DN+vCc5ijfuhjrnKNtebt3+SiAlY80h6nbn7IU1GcFJCo/+3YedPtEz2mCPnsFbqmT+zisuqr7e9wp5I2fdDurn8RueHcDgz+6mXYlYm+9kakZK7XHJO3j1jD6Uv1AwFKCE74zML6vdMLZkSbzX+TTDUFKO+mlQ16lx7se5p1s4KvxoWb+/1A3onCABP1nnb44RojjUb3F/WcF05PAcCEwdjQ/jIyvdiiRZcQ+qWqr26vMlK9efcXfB1K05fxfhAZO1fsVHlINQ+v+IbXxXDYO9/iw0QO7YccWbfKrm2Y1FtkUuT7LG8SmABlVRn++0nycQgOBTQffStetuMPWXOpamx06H1QUfyvTf8fH7P3XWFYk1fmC66jgqnZow4J/t7Pir4pPaSRrkTDxQBbnjyUyryBEmOdFJwqXnAhFWuc86IBAHA/t9f5siWtr1z03f7vXJWSOMuPPZ6mOMZ69eYJ5Jmp4AjWlsPNJtyo5gXx5LidLJ5iRyP++/8eVYF1Av5vURGIzX/xEDDCTa3a4d67ebrQFjQ9gQ7OxCiM+zLs53BL0YqA6//sa60/QWLsyQAXVIga/PFqsnG6eiYqv6JZTBFGyk02Mai6MujlwrhQMXfcDNzgzIb1cC7kDQ15GIdxGcakmB+vsIY/yEt12BVo9ClFYrllVltvjM0zgjl9A
 fzATrJII
 gc2gsSSmsCn10zupGPaRRELzuaH8tN+ESgwILj0TaNYOmqv36g14uKZcfj0G65cHWV/yvpyS4sDZVx99+Ikg0Wn7lDK9akOTHfBB/F12UFqFa/ODtGsVrRGMau38uNJMZWqXtUrsRcHXIyR9dIrtcB0/S4x51QMDB7c75OFyN1K1/k7r/ks4P4hyeAeG5SljDmaEsnfyvIstckmkJDnXq1s7S7NYzR0elJBNIt1MnRcafdeY6bwO5b/8q/DQ/C+i1C899uywXi6Kv9xYRh7UAq3JUpSiXEk4UnjEzhDxu5jA3i7ksStD0aUs4x+eFltGxojHweTpoE+3J2JJu76qqTaxhr82e5mk92F7E
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/4/25 13:23, Chen Ridong wrote:
> From: Chen Ridong <chenridong@huawei.com>
> 
> When enabling vmscan tracing, it is observed that nr_requested is always
> 4096, which is confusing.
> 
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
>          mm_vmscan_lru_isolate: classzone=3 order=0 nr_requested=4096 ...
> 
> This is because it prints MAX_LRU_BATCH, which is meaningless as it's a
> constant. To fix this, modify it to print capped valued.
> 
> Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>   mm/vmscan.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 584f41eb4c14..a0a74cac947b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4404,7 +4404,8 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	int scanned = 0;
>   	int isolated = 0;
>   	int skipped = 0;
> -	int remaining = min(nr_to_scan, MAX_LRU_BATCH);
> +	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
> +	int remaining = scan_batch;
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   
> @@ -4464,7 +4465,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	count_memcg_events(memcg, item, isolated);
>   	count_memcg_events(memcg, PGREFILL, sorted);
>   	__count_vm_events(PGSCAN_ANON + type, isolated);
> -	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
> +	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
>   				scanned, skipped, isolated,
>   				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
>   	if (type == LRU_GEN_FILE)

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

