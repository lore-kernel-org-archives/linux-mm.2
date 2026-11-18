Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 81B91606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 11:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=lVyk9HkT
Received: by kanga.kvack.org (Postfix)
	id A37AC6B05B2; Wed, 18 Nov 2026 06:24:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F866B05B3; Wed, 18 Nov 2026 06:24:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 925216B05B4; Wed, 18 Nov 2026 06:24:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74C676B05B2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 06:24:10 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 14371A82C0
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:24:10 +0000 (UTC)
X-FDA: 85448005860.09.1E15658
Received: from mta1.migadu.com (out-124.mta1.migadu.com [95.215.58.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id CB4AD20006
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 11:24:07 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lVyk9HkT;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795001048;
	b=eoI0JSLCVl4YbrT6WkDVoCCcyCpuKIhnkbzgIQvwdYHwbbUl+PLSLXqEhemusnM5oi/QSo
	pSZKWS5045jXW2IinhAvds/Q74pTHcFYQQ0qe9hHX3rT4E4ZeRMZWYzGuZmu+KNOKQ+7jz
	uwDNxj75o0J/WzAM2eHpNz/4BDz6a7s=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lVyk9HkT;
	spf=pass (imf03.hostedemail.com: domain of ridong.chen@linux.dev designates 95.215.58.124 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795001048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kGbil/6uybiLL1poJa3GteC+l0GAriycnTYZK5gcfN4=;
	b=dRF/sMhOEeMB8I1ZIVHZf27GgeEuA5DOMZBgB8fpyLg7WqQfjFntwGHgpMu2pa3WiDGNgn
	TlJufN47kncdFe/GGoSY5BaTE4Ab7wXPem280NL+rySmefyKnofwU4ev125Nax80PwEhZv
	z0+ryLcS74b61VKjb0dNzVonoPXISSc=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=ceQJf4xOqkkLiYn2mCtm+HSzCEGYSqHZfwzWPUGAHIY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795001046; v=1; x=1795605846;
 b=lVyk9HkTrctueEmt15F1jiyRMHgiqX1V/tFI4EpAMcVHYh46SloY/QfA3at1qJWfn7PKz/g0
 2tTrnNfvhel7ZiHjtNcUCPSRfl9aWDWk1a5zYGftGKiTrkCl0cRkjAwzlmYZSR4gxpya4KkeFrp
 8i4iROYxx/hnh2OtTDZG1+5U=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 35a978f1a9a4df4f;
	Wed, 18 Nov 2026 11:24:06 +0000
X-Mizu-Trace-ID: 35a978f1a9a4df4f
X-Migadu-Flow: FLOW_OUT
Message-ID: <e8ee4599-5006-43da-88c9-5aeaf2306c6e@linux.dev>
Date: Wed, 18 Nov 2026 19:23:56 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 06/16] mm/mglru: return for unavailable anon reclaim
 earlier
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, akpm@linux-foundation.org,
 linux-mm@kvack.org
Cc: axelrasmussen@google.com, baolin.wang@linux.alibaba.com,
 baoquan.he@linux.dev, hannes@cmpxchg.org, hui.zhu@linux.dev,
 kasong@tencent.com, kunwu.chan@gmail.com, liam@infradead.org,
 lianux.mm@gmail.com, linux-kernel@vger.kernel.org,
 liuxiang.277@bytedance.com, lyugaofei@xiaomi.com, mhocko@kernel.org,
 mhocko@suse.com, qi.zheng@linux.dev, rppt@kernel.org, ryncsn@gmail.com,
 shakeel.butt@linux.dev, surenb@google.com, wangzicheng@honor.com,
 weixugc@google.com, yuanchu@google.com, zhangbo56@xiaomi.com,
 zhuhui@kylinos.cn, sidchintamaneni@gmail.com
References: <20261114200803.23129-1-baohua@kernel.org>
 <20261114200803.23129-7-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-7-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CB4AD20006
X-Stat-Signature: gm835hiqxdtmnk1sj384mjpaym8sqk38
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795001047-97552
X-HE-Meta: U2FsdGVkX1+wyaT8Ia5zeLmOWFgJoNEJOzB605w1LTUyB8/VueY+2ySGmEFHv5N4ZcnP7rld8UkcQGLAeQDkX/s5yesMVURd+MHDQDwZ2IjH1elb3Y75rPBLX36HShV2SJK+gy/bYQ2LYuL2mgZqKygT55TJR1D6wcLq7UH2/9sVW0L+XNbJb2bklu+sweZrZif6lLRmkHHWX10xEmfcO4bXE1smvEgoxnN8u4r2eLqIkPEE2V4k8iBRE/Ltcv42F+CgnTfXHANeR6Y4e9Qp//WibL3nbbhd21kWzbHn+JWzEKTq/NYRbjctVYf1V+aPKZk65I51+aFcz6/7H8ZYPLYxKb1Q2ZH9AEDJ5Tv2DA/c6wOWVNNDhz42T5xxQ0kd+Cd5TkBBzwaSHiNfTZ+LydE0de3YQuhAB0psW1K8F4Dzwifq6KjqvGZRMWvdI4hCHuJpfUtrwW4rCbHIXHoR/qWm+Gsjv+3z+P4mKgO9xg6uM0RvsUY8cN61hDeENe/Sln1y402xetUCXPomKTsuvPSIbZ0PntZuNraQX2Mt3OGRt2uZM2WZrjd9JuH40rzsMZ6Iwikypj9HFLaFdE8uNsEwg4pb8BNha9GeqsbWCyp61tu4UMqKD1jWv+qkr4/u2t3CD+fB6TKwG6tuu100bYtsqjSWU3fFj4L1Jxy28KhIvEvNp0o6XSI2rd53/yJpC1BHXOWSAx/NizStRGD6zInEPOzwfHUPUekyELsx+3LcjRmxKGMHDVeOYFuMj7rK2Da7y5Z50cbUGHydA+eIQDAxIvTUG5Odw6DXqQbZoLNoXPoigHiY4B0gcmMgdZwlb02/EKB9BxfmVmLauJjjK2EV6fK35Htlg0y6CpVXytn6/uoYRIahOGqev65YNVfGId8yYt2cVg1qv8mjOojc3I7a5fkQKLeoz6vyMTTW0kw7oZO6ycUWArE1nMun7/OF5J7WO0J3ohi4ovXKtHx
 mRk09O5k
 9U2nTnMlp1z6oSm/BeT5DafJDF2ruI/TSM12DKkte+Kh/xGovuOgWu/71f2jekipQR+kYeY9htAPl9qFnwB1mL0CSuW8cxVOi6on8j0jibI2z39DspYYYLJQ/5dBMUrJbKUqk0n+eI23fVlCdt2dOawriQEFZb8/vXjd38SvptM5leG0OSSdV6Fj5tEW6sfpuscRCkAeZudU0Dq2eo7ZMYRQjNDK/wShpK30AM4XZ2WfX0OnbifCY3wJFV9gV9S/qoLUCo61qZ1e23CREWEOrXWAYFRvU0J6t4ZBojKdrIlwfNPMgkq8lhHCnzhgYw4xCzCi8EeEQPMr/VRiPaHm8QNqhNzl2p/M3gsCE19oex6mxjD7j/kGKDwVCRvXYURUZPbTX3ZLG7uRW0s5GGhYeAXa/cto75KOTj19qQoQexCmeJuw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:07 AM, Barry Song (Xiaomi) wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> No feature change, just shuffle some code, prepare for later commits.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---
>   mm/vmscan.c | 27 +++++++++++++--------------
>   1 file changed, 13 insertions(+), 14 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index b3ce4a550a62..f7fbe91fedf3 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -5060,20 +5060,6 @@ static long get_nr_to_scan(struct lruvec *lruvec, struct scan_control *sc,
>   			   struct mem_cgroup *memcg, int swappiness)
>   {
>   	unsigned long nr_to_scan, evictable, sizes[ANON_AND_FILE];
> -	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
> -
> -	/*
> -	 * Proactive reclaim initiated by userspace for anonymous memory only.
> -	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
> -	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
> -	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
> -	 * work when there is nothing eligible to reclaim.
> -	 */
> -	if (swappiness == SWAPPINESS_ANON_ONLY) {
> -		WARN_ON_ONCE(!sc->proactive);
> -		if (!can_reclaim_anon_pages(memcg, pgdat->node_id, sc))
> -			return 0;
> -	}
>   
>   	lruvec_evictable_size(lruvec, swappiness, sizes);
>   	evictable = sizes[LRU_GEN_ANON] + sizes[LRU_GEN_FILE];
> @@ -5126,6 +5112,19 @@ static bool try_to_shrink_lruvec(struct lruvec *lruvec, struct scan_control *sc)
>   	int swappiness = get_swappiness(lruvec, sc);
>   	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
>   
> +	/*
> +	 * Proactive reclaim initiated by userspace for anonymous memory only.
> +	 * SWAPPINESS_ANON_ONLY is set only on the proactive reclaim path, so
> +	 * warn if it shows up elsewhere. When anon cannot be reclaimed (e.g.
> +	 * no swap), return 0 to skip the scan entirely, avoiding useless scan
> +	 * work when there is nothing eligible to reclaim.
> +	 */
> +	if (swappiness == SWAPPINESS_ANON_ONLY) {
> +		WARN_ON_ONCE(!sc->proactive);
> +		if (!can_reclaim_anon_pages(memcg, lruvec_pgdat(lruvec)->node_id, sc))
> +			return false;
> +	}
> +
>   	nr_to_scan = get_nr_to_scan(lruvec, sc, memcg, swappiness);
>   	while (nr_to_scan > 0) {
>   		int delta;

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


