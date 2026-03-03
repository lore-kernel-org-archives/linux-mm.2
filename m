Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D685EC047D
	for <linux-mm@archiver.kernel.org>; Tue,  3 Mar 2026 09:34:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B651F6B00B2; Tue,  3 Mar 2026 04:34:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B22296B00B3; Tue,  3 Mar 2026 04:34:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5BA06B00B5; Tue,  3 Mar 2026 04:34:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 925CB6B00B2
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 04:34:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3526713AABB
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:34:27 +0000 (UTC)
X-FDA: 84504241374.20.46DAE1D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 5CA334000D
	for <linux-mm@kvack.org>; Tue,  3 Mar 2026 09:34:25 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TrgZIT4+;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772530465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BpSS4EIXQ00IZEPJD8F6ezjT19ORTYn2gwyOKDkMdiU=;
	b=kV5CxCFcQMqWPdrSsRYtlVeSMoHvbRSY77FfVHmlTvHof8FDFapdtsxC+x5zhmS/oKTxAw
	8uH+xOgB2Ios7eqbFDcvwSkgyBA4jRulGLUZMb9ymISGbAiWS3hOBRF+VhDtjiusr606R2
	BMKNecdMVFORvvvnk7ZZTl8dXq5D11o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772530465; a=rsa-sha256;
	cv=none;
	b=zT2ZjUsAiMaS+Uib0+JzJhXO8Ecsl8FHBcb3puw/HyQ1P90+tRJz1wDrINSwx1T48dcPz0
	f8yrYvN9MI85dkLMN6SEr+4n8PFFHrbgZ1BQSoU8pQEuhZG41aY+OAA+vTg2QijlPoOHFz
	mKdgqLKyhoAptcni7qnkeC1t5WecKDA=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TrgZIT4+;
	spf=pass (imf12.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55E4F43E42;
	Tue,  3 Mar 2026 09:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E94C116C6;
	Tue,  3 Mar 2026 09:34:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772530464;
	bh=aF0geMfZfg7K36R3UA50A5lGdrThrnCyNqDKuaHXlUU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TrgZIT4+ZXZ5Ij0Pckh4JcvO6r3FTtQqoX3igL1DYRgXGSlUB2kmvsCk2EWI3KSOD
	 onrlbftUWavPQo3y3shH+1g15Lr3BxFMVeJsqyZhGmTL+Hi569qcQBiA+c0+nBRiU/
	 U16dsnQKo6xoeAX5L2v4GQ/tjadQ1c/ddea9YUAXMMdyIov7FAaogWAnGnhuRzsy+c
	 R/4BJT/0udRLDF2MjHIcVxziOE3GLDi7v2dH7cg6Ws7zBMYALep8TU7+o8tqygQYQo
	 hNtH2kzCuJIIUJyJ7FSnrGzIG2lLUna0yfybyDh5aMZVdC0IpopPBjIZQTVKjfzaMa
	 pTJrRFC3GzrmA==
Message-ID: <8580309c-7166-4475-80de-fb2a11a8a1e8@kernel.org>
Date: Tue, 3 Mar 2026 10:34:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/5] mm: memcg: simplify objcg charge size and stock
 remainder math
Content-Language: en-US
To: Johannes Weiner <hannes@cmpxchg.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Michal Hocko <mhocko@kernel.org>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Vlastimil Babka <vbabka@suse.cz>,
 Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
 Johannes Weiner <jweiner@meta.com>
References: <20260302195305.620713-1-hannes@cmpxchg.org>
 <20260302195305.620713-3-hannes@cmpxchg.org>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <20260302195305.620713-3-hannes@cmpxchg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rhkoh3fsj15646egcyqumebnk9ahri9t
X-Rspam-User: 
X-Rspamd-Queue-Id: 5CA334000D
X-Rspamd-Server: rspam12
X-HE-Tag: 1772530465-493759
X-HE-Meta: U2FsdGVkX1/XQBHeDAgL9zCNK0CGzIMAwcZhwLTV1ZBRM+xBj6B2oW1LwO5rEokNZI5mU+jhlBJRqEViP0bH+sv17wKsBwFcJGlKGC7uK8q7nQpIBxwd500fS9lpapMHomUQKesrkBwx8MDPxFHhJFs0LHsfkSc0WCJdmkYNjSTj0qsSF9FNH92ayuAOMcMM7uDWjKig913e8r05Gwk+KO4TeA0xNMvO/HT1cJeTnG2yLyICYWz96AlCq7XotqlvDeITOU21m+frEsyXtNX0YRHHf4hNCF+e6XvS4NkY/Q8+jmos52wOsZ5TznzWJvw7GCRDpD0dBZVD74j2UAw2HiwU7oWtaIURzm0lSDYzShWzEEzwZJF3Kdlv/X7hmQWcAXTc4Dj75Lm+Bw8i6wLkdJxX3/0I4K2ZFmpDIhVmDG4zc4/tePPfm+I3CVDZelk6pDwsTtQvxqVVVDZiYmxvCGzULgtEBAGfg09O3aIIkIv/oJPgpq6OtKRzUd7QyCWmlwOMNP6zxmse+Ir2+UTfBr8blqybFR/ZYgxDlfs0h8p+3LZgKRAVfmKm69xL7zboTi509BRWarFgfXtH64Q9kY1z/lO/6gWeW6N725I6VpA7FqkH8q1xbLXL4ucrZRoZ0Hx1Qcm1Ee8eUJr0PdhDAFsSABmjkbU+vx10TKMkK8w3H5LcY6N3RlKvBjIW20og8z/uxoGovTlqd9WLmhYBG+NNDoWnbSrM6b4IIeVyySbF+LaZNqXGNUeaeUxUSj3Q/PLS6Nk3MyvsirXI5aoUcaav3n616W67mJAkoAU6m4C51+7kzxSSVCHMGJWsSOYAC2nEixIFcbW+W0sKXBSv8b1TQ6HfK1wmR1oxRErYjw3lnmc46Al1MZTZ6H/wHbhrATD3aOIgnUMV2H3uik3qnyV69F73IyaiVHmbl5R8SLn8XombyY11dlpyNCBjpb0Ogc+xia6LmGdorS3MMBT
 gJ3eu+1K
 tXpDpu0DAghnRzhOywix/osk2QJisEhWZPTsfF3tVHXEWCINaV5nUMNmRRSijfTjjCAnvqd4RRso/Kvreu+SLAWqu4wwCaw6sKhDDEOq6UEBGTinEHQo3bSZUXvmxslV0B1ngXl33QDHHNO3fNPrROR1V1HwU4Uazgm5iBY597sdlPou/kn+kg9GAVFkUPpRCEn1Gc4M2ndTM6UgiO9Xa/XAXJQhb5Iozw0vrQsboPEQv7e1fewq4FWa0tgMEursrqd/HfMYVe5qB0CRVnWiKM5GgKPiK0jJSywX7iM5UX85I2ms7E00rlhajxLfddRQk4p2hPScXzmKuWGWm5offRZTnCpI2v2Ov3HF/KLBHwyg8Si0Z+i5wC5rIHQ6f73Wq/16uoudpfqmF9ayjKDUzl8Ss1Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/2/26 20:50, Johannes Weiner wrote:
> From: Johannes Weiner <jweiner@meta.com>
> 
> Use PAGE_ALIGN() and a more natural cache remainder calculation.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

> ---
>  mm/memcontrol.c | 16 ++++++----------
>  1 file changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index a975ab3aee10..0d0a77fedb00 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3417,7 +3417,7 @@ static void refill_obj_stock(struct obj_cgroup *objcg, unsigned int nr_bytes,
>  static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t size,
>  				     struct pglist_data *pgdat, enum node_stat_item idx)
>  {
> -	unsigned int nr_pages, nr_bytes;
> +	size_t charge_size, remainder;
>  	int ret;
>  
>  	if (likely(consume_obj_stock(objcg, size, pgdat, idx)))
> @@ -3446,16 +3446,12 @@ static int obj_cgroup_charge_account(struct obj_cgroup *objcg, gfp_t gfp, size_t
>  	 * bytes is (sizeof(object) + PAGE_SIZE - 2) if there is no data
>  	 * race.
>  	 */
> -	nr_pages = size >> PAGE_SHIFT;
> -	nr_bytes = size & (PAGE_SIZE - 1);
> +	charge_size = PAGE_ALIGN(size);
> +	remainder = charge_size - size;
>  
> -	if (nr_bytes)
> -		nr_pages += 1;
> -
> -	ret = obj_cgroup_charge_pages(objcg, gfp, nr_pages);
> -	if (!ret && (nr_bytes || pgdat))
> -		refill_obj_stock(objcg, nr_bytes ? PAGE_SIZE - nr_bytes : 0,
> -					 false, size, pgdat, idx);
> +	ret = obj_cgroup_charge_pages(objcg, gfp, charge_size >> PAGE_SHIFT);
> +	if (!ret && (remainder || pgdat))
> +		refill_obj_stock(objcg, remainder, false, size, pgdat, idx);
>  
>  	return ret;
>  }


