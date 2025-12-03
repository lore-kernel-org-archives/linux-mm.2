Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F38D12D47
	for <linux-mm@archiver.kernel.org>; Wed,  3 Dec 2025 11:33:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D40B86B002D; Wed,  3 Dec 2025 06:33:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1E156B002F; Wed,  3 Dec 2025 06:33:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C55916B0030; Wed,  3 Dec 2025 06:33:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B83156B002D
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 06:33:16 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 42B8751A53
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:33:16 +0000 (UTC)
X-FDA: 84177948792.17.B15155D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 820581C0014
	for <linux-mm@kvack.org>; Wed,  3 Dec 2025 11:33:14 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nCztgqpj;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764761594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SuMXrJe9b0QnrPCsmmwMPcceQHG5SR0InixorKifxRk=;
	b=7O8yUO7Y9/TkHv22Mh076L53Eh3Z75AyOQlqfxlkQfvfw6LfIxH3qcpwRGldI0pYtN5l9l
	b3TzxgjpVu+amMMtNFn211uSvHl/g4EXCCAZJ+Nl5Skm5ixP91AD5WyrwYNHaS6yayoTjk
	U0BNZGoLIX1mPhaUtTFaZoke7AOHSZ8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nCztgqpj;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764761594; a=rsa-sha256;
	cv=none;
	b=JxhbDMoc12XeKw42JEmnKBPlFLAAIt3gjrYuPVi0vc2NeWKTKmmh0lIUbUsh2BYm56ilfc
	NJ1NRiSIBDs74u6ZFcTjJ92x/IwVl3w7vVzluU4yeadaOF8B13HStv8KcTdIO2EVe+pOlF
	PYQXTErClMMfqbtbWXDwcGGoXc57uio=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C1E9560172;
	Wed,  3 Dec 2025 11:33:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860C1C4CEFB;
	Wed,  3 Dec 2025 11:33:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764761593;
	bh=qkitV7n3IcZwSor/OK4RnlgMcECsoeewa2IMTxryTvE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nCztgqpjFPJOQS/0o8qWY8aAUUH6aR+l4w2XdhKpQ5sKYB7We7KzslTZ+3nbQyule
	 FgDl4wiQ/l89eqUEeqViaSnvhZJV7idUHiDDE969P5md22Jl+yBQO+lkRAZ+/Cw0Y3
	 sR+TUxQGQaqy2kaPcwwCb0dKgXkr+ldhiFlZ2qDQX09p6Tegf+fDUQ0gyzAny1HoTn
	 IPrOjvMqN+g3Kx9U/6hWKIE5mDFL4KUIlwz98MKWCZeQUlllBYkQgu3n4fGE23flzD
	 a+EHtyqOklKWqSyxCtoVsoNTx3TS9ofHegddCyTO7Jj4FV6oLoP65kLXFpvm+tOOcD
	 vijTV0BaEbnvQ==
Message-ID: <98cbf348-ff21-4c90-af32-b8009c34e5fd@kernel.org>
Date: Wed, 3 Dec 2025 12:33:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next] mm: vmscan: correct nr_requested tracing in
 scan_folios
To: Chen Ridong <chenridong@huaweicloud.com>, akpm@linux-foundation.org,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 hannes@cmpxchg.org, mhocko@kernel.org, zhengqi.arch@bytedance.com,
 shakeel.butt@linux.dev, lorenzo.stoakes@oracle.com, yuzhao@google.com,
 jaewon31.kim@samsung.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, lujialin4@huawei.com,
 chenridong@huawei.com
References: <20251203094002.1745458-1-chenridong@huaweicloud.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251203094002.1745458-1-chenridong@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 820581C0014
X-Stat-Signature: z3gmc5xa7ix6nd4weqy96jt9hbj716jz
X-Rspam-User: 
X-HE-Tag: 1764761594-79978
X-HE-Meta: U2FsdGVkX1/g/L3qKG3VkPl5kispyp/YV2/AItWbmsUpcQgsEWlWiIMj4ZLgJ/hwfhyKXRBWebx6FbdgL81WI1relkuFjVgRIc4iUugk4kV2I8Cw/fDb2IIxtrVS4qb3g4BsLMB1Uh4pxU9JB5+N15jrc86cwiy3eJl4cICMlSwYNeWEolp4FHZqJfSlC92YnzcE9I4oYAW8HTT2hPrhOlonOqPZM5OhZ1OPQVvAN7RPp2+22cHfuE7tAzylkd0kXnjg3JrzBLJuvxQETovh5wAr9D9+AFBikDY8DUWfS/fMOgirEBmNH8luIs06+lkDnsbINrVCrUgMsFK2dV+OiKzu1UhmOtktWS/l70Zvdnc9vLxuojp6kGqv9/eexcSqyV86cs9RAkbCqTVgsjLryE9Lmz/iGIgjYLtvMY8b4CYr8B1rVDjXO45Mo3FG4/qxzL7p1/QD4lkiRX/Ymk2y27dHfiCFrETeXDXHQS9fHt0rA6ypaHRKXtq3cu/VgedUA1gbsBFSbOmit+nVRhyXOocaJw7O2gnFQxCOqn7z76b3INUQnRUxT8abqfrFH2pbN2JaFt5So6Y9HqFhAvrAomsVwsAXYAP1gB3O3KNWjZsm+s6AxN2NKNcAy4+k4ZfirYhbC6R0s+PPxVfviiY/gmPU7vpOAn8sLAx3UsrEoN1Qt3rWmGLMHePitktYlbIelnEndsY8phFt10tdlN1cljL65PHcgiVvwbKf9oJCg89VybPTrq3uM7j4Xt77QIPhLLERYoSiHaljgVLATOFc9QRQg4o77VVDoCT8yL6zv3R/qxKwXnCiBoB64+zy9FE9y7MeMFjIv53aw/S8yZNXK4ZX0yZ+cfihMuBm6sR3s+71iDVvSOXsSFLMSrDvcBX5vRITkjkIetp/rdPj6xihucx1d9s37sBMRQ524NOXg6XRrbpJbN4S9oYA1PaiZ+UwlgxKKaKAEwtZfpaoyqz
 ZGtGAHH2
 qj183hRGi9oPQGP0P4QPZanoD5vF0DFJnWmXrp5Y2qCw0SdNmeOu+IMl8O2IZbuXdmzdUGEQWRFqpm55rg3UxJabaagmRPz6LCP59EWUSnojllibERqdjyrzJG8eTyO6CPX43D3+4TyviY35yu6vc0y/ZI4qcps1ol3Y/WoxkX+jqUO2w6J+zdZj30gOPD7cn4ljjcIYv8uYJUBgGEciHH22x+8tQ4D5AhIkgj1g0XYkGD+/BwWS5gsJ7eFVUHpu0TMMyYecrYsXShqAwMTj6DBgT18qqXVsA/LiMH7v/w42/KidLoEyN6phpyPcInd8QAa7DDNEPZRwGR/U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/3/25 10:40, Chen Ridong wrote:
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
> constant. To fix this, modify it to print nr_to_scan as isolate_lru_folios
> does.
> 
> Fixes: 8c2214fc9a47 ("mm: multi-gen LRU: reuse some legacy trace events")
> Signed-off-by: Chen Ridong <chenridong@huawei.com>
> ---
>   mm/vmscan.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index fddd168a9737..8cfafd50a7a8 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4601,7 +4601,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	count_memcg_events(memcg, item, isolated);
>   	count_memcg_events(memcg, PGREFILL, sorted);
>   	__count_vm_events(PGSCAN_ANON + type, isolated);
> -	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, MAX_LRU_BATCH,
> +	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, nr_to_scan,
>   				scanned, skipped, isolated,

We do that in isolate_lru_folios().

Given that we do

	int remaining = min(nr_to_scan, MAX_LRU_BATCH);

and effectively cap it, I wonder if we would want to trace that capped 
valued instead of MAX_LRU_BATCH.

-- 
Cheers

David

