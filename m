Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18F7606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 13:05:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CPs0bHRO
Received: by kanga.kvack.org (Postfix)
	id BFBAA6B0A08; Wed, 25 Nov 2026 08:05:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD2FF6B0A09; Wed, 25 Nov 2026 08:05:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A73AF6B0A0A; Wed, 25 Nov 2026 08:05:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 71BFE6B0A08
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:05:48 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CE41A80E9B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:05:47 +0000 (UTC)
X-FDA: 85473663534.19.A2CD8A4
Received: from mta0.migadu.com (out-18.mta0.migadu.com [91.218.175.18])
	by imf27.hostedemail.com (Postfix) with ESMTP id CE78C40015
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 13:05:42 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CPs0bHRO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795611946;
	b=z6IQIly4bv80UZZXPSUJcVcRuttSxXhawMgsXs75la3H4zFcdiRoG3zTBu86wIJ5pWq99s
	8W+OTd7kL9+ejR01UlC89fkd6Sh4ZhRs06CYqVopRTe9QovSdtbtTjG2MHewv51MRFYXXo
	4ZmStsozeCftB1IghCqH0AGFH7iuL2U=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795611946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LU+lZMJ7C1LRaiuMHqC0yX/sKSPUmOi9g87GKed2nkY=;
	b=75L1IluogQmnyeX5pt6vExRVoz8SbKLC9exnQbeowzNYz6UE25iPeRnXSwLDBmTFCgUNLx
	iAAvJfSO/Wvn/vrSaPaOyvVFpTeJvELEpKG9xKOvQlxP/YTtAd+SK+Q+avVILSPdZSkaOt
	bqU/q09rSHR61PvU4UFpONYN66LUXXA=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CPs0bHRO;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.18 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Y5XrY5yN2GLoPwf0NATfst7wtuL8/+fZic3NtYnstlw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795611941; v=1; x=1796216741;
 b=CPs0bHROZyEzt8IgGkxomZpNGbjPJxaWSrv3NIxhvh8k2MjdpmRcROKUAqeUtS16ZQuur+z+
 SI8bTWTNCddfMmSSPvVoVtpiuLvpDSGaP16wIWo55oItIUVozvTc36Xt5kYTRNYTPd5cM0OHONA
 S4HrfugSFtcdo3113rDgyVcw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 4cf78b17849a4a84;
	Wed, 25 Nov 2026 13:05:40 +0000
X-Mizu-Trace-ID: 4cf78b17849a4a84
X-Migadu-Flow: FLOW_OUT
Message-ID: <47d6cfe5-f2a7-41d7-b397-df30429b216b@linux.dev>
Date: Wed, 25 Nov 2026 21:05:28 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 14/16] mm/mglru: Avoid prolonged anon reclaim with
 swappiness=200
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
 <20261114200803.23129-15-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-15-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User:
X-Rspamd-Queue-Id: CE78C40015
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Stat-Signature: dsffbe4c6x7zf44ppoqf5pae6ogxpr6j
X-HE-Tag: 1795611942-621295
X-HE-Meta: U2FsdGVkX1+McCSAg0KP8hGDJTcosN1HckOrg/ufwV6UB9yeBVNMLJooryWeb4LRDxYEC/BT5l/hwHWfoeEyl4tfkVDGSU40fCgZo0MlNvMGfVwluVprY0/bmH++ZzVWJvrx/ddqLmaHQgYdwDbz09RqXeKFKXQL6kEwku0XGNXklMZyr3y57vQfC9SsB3u9yvbv5EzfPfrdL4z5S1FfXBPY38ZE5/mfZfm0vgGC6uafBVe2ENqPSvyepk2JWSIj/0mYwntbS/dxQeD5Yr6+9sQPyTsyQ8k4ibnD8yQrjJ2dTWB2SyQdzQ9BhR6N2NiHSGjfIrV8urBMX94t5PuZxpm6INuMfu7OVzn+/rHWlZ1iIVx3/8kK1JlVS//PcShX5vi+AsPhxpwv8dxbckpNiV0jLi4x0Mx1leiI95mTnhEyj10SFNLKJpSm6EbWgr1aRvMBvZ8QYUS0mnNakea7bem2fXgaAh2sxBZfyXzG8/UR397azmEv3ofTuZ07i0HKwD06KQdyTnx9mZ7HoOTmMNiEoaUe7MuxL6NMrylRNBMfFDU03K8o3WKN5A6vxFDlCPIQ7Ill6lLrnWm42eLTTKOFc0TlLYUwzVhq/XphpmbxB85UuNfYb8R4w+mAevWDllO9NxP9q933BxvFRqNwMo6BgEHMaqO1JC0k77Hg4KNEtuUlk0svLCM5YWDE+FSfRFMNgPgOlq57ZKEAW4n3m3fnHPKT0GtRpyzhJdcRCbylTgbC4yYvllyrZccKl27yvC7bVAibGtuefWt5GnuIZ7mfVwsMmnJYP3x56eXv7McufdsXpAxOqQiThsv35Cr1221ZENeReC4VR94Wa0o4u5efisarThylYvm/4jAPMVQPKqBR9rgG680USHf23PORC3wSjPKXuBIY7/fKxbe+YTcF08c9YWpBunHsNswdGGDIr8H0m9wpzxLSOlTgTdSvSEkH2VbYsboG7oP8Fl1
 DdwtQAsH
 6OLqGHT8TRUrPUz4fvmo3xyr9VGxTZvnQda3LozzgAQz+cSTO4USnZz6yIMFdmFvww8DBvAYJ5KBn8osukvMoy9sL3G1OMuWXmkyl5eaO9/egQTVgix/ahnpYlpLTvtKMtJnvtn6A0Z2m59Iw/15KoScLHnVlY9jPFj2L1MH4PwGOwwkYN2zUhZjKFjIXvPc7dw00/22KdHIr/qCrqW25op6XFjWHInf6rmlj9ipzjQ6UmNoRnJNFCpzkzmrMdNg/V84xYGdZpQZ6UBdmOReV8HrrbZD8IPVbsY4hcGxUM4u9zHvLmrDSk0rFC35anDd48bqkW2lATl9P3N6+YWLSaqPV5W3RmPKSGPB5xSxABzA9lCujRHRpIgpZCqQbh9wm+OmDbqLNAfDbYbXbyRoHYqv+IzcYEGrCRUJTQ49FoTgz3WSXTN8Gre6W7toP59yOGAoNL3uzoe37TL0xR5dPYimFQ55tdkTlw2HpdbT2yL5rcmPLLn7axV/N6dU2CLDGxipKO4FDyctOXCFLh/+Va7GcgrqiV6fKU5cyIomvUaSxqZAfsQrgAzAaUHS+AH/Sj/pJUN8iJ2IczPYXYCy8As6ZQf7RzmQnjNJOyAkdLQNoN+g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/15/2026 4:08 AM, Barry Song (Xiaomi) wrote:
> From: Gaofei Lyu <lyugaofei@xiaomi.com>
> 
> It has been observed that swappiness=200 can significantly slow down
> reclaim on some machines, with some workloads running 3x slower
> under MGLRU than under CLRU.
> 
> This is because swappiness=200 currently results in file_factor=0.
> Give file reclaim a small factor at lower priorities, for example,
> when sc->priority < DEF_PRIORITY / 2.
> 
> Signed-off-by: Gaofei Lyu <lyugaofei@xiaomi.com>
> Co-developed-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>   mm/vmscan.c | 15 ++++++++++-----
>   1 file changed, 10 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 6cb905162cba..abefd91f5b95 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4898,8 +4898,8 @@ static int get_tier_idx(struct lruvec *lruvec, int type)
>    * We don't calculate the scan cost. MGLRU uses lazy promotion, which will
>    * cancel the scan budget naturally.
>    */
> -static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
> -		unsigned long total_scan, unsigned long nr[])
> +static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
> +		int swappiness, unsigned long total_scan, unsigned long nr[])
>   {
>   	struct lru_gen_folio *lrugen = &lruvec->lrugen;
>   	u64 refault_rate[ANON_AND_FILE], anon_factor, file_factor;
> @@ -4956,7 +4956,12 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, int swappiness,
>   	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
>   
>   	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
> -	file_factor = (u64)(MAX_SWAPPINESS - swappiness) * refault_rate[LRU_GEN_ANON] * file_weight;
> +	if (swappiness == MAX_SWAPPINESS)
> +		file_factor = sc->priority < AGING_PRIORITY ?
> +			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
> +	else
> +		file_factor = (u64)(MAX_SWAPPINESS - swappiness) *
> +			      refault_rate[LRU_GEN_ANON] * file_weight;
>   
>   	/* Cross-multiply the ratio above. */
>   	anon_scan = mul_u64_u64_div_u64(total_scan, anon_factor, anon_factor + file_factor);
> @@ -5144,7 +5149,7 @@ static void lru_gen_prepare_scan(struct lruvec *lruvec, struct scan_control *sc,
>   
>   	total = apply_proportional_protection(memcg, sc, total);
>   	total >>= sc->priority;
> -	lru_gen_balance_scan(lruvec, swappiness, total, nr_to_scan);
> +	lru_gen_balance_scan(lruvec, sc, swappiness, total, nr_to_scan);
>   }
>   
>   static bool should_abort_scan(struct lruvec *lruvec, struct scan_control *sc)
> @@ -5910,7 +5915,7 @@ static int run_eviction(struct lruvec *lruvec, unsigned long seq, struct scan_co
>   			return 0;
>   
>   		lruvec_evictable_size(lruvec, sc, swappiness, nr_to_scan, sc->reclaim_idx + 1);
> -		lru_gen_balance_scan(lruvec, swappiness,
> +		lru_gen_balance_scan(lruvec, sc, swappiness,
>   				     nr_to_reclaim - sc->nr_reclaimed, nr_to_scan);
>   
>   		if (!evict_folio_lists(nr_to_scan, lruvec, sc, swappiness, MAX_LRU_BATCH, NULL))

LGTM.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


