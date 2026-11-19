Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 465D5606A335
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 10:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=B+Mfu50Z
Received: by kanga.kvack.org (Postfix)
	id 629746B05D8; Thu, 19 Nov 2026 05:57:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DACF6B0609; Thu, 19 Nov 2026 05:57:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFC26B060A; Thu, 19 Nov 2026 05:57:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2F43C6B05D8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 05:57:57 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9B618160A42
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:57:56 +0000 (UTC)
X-FDA: 85451568552.28.CBA2418
Received: from mta0.migadu.com (out-222.mta0.migadu.com [91.218.175.222])
	by imf22.hostedemail.com (Postfix) with ESMTP id 3EC64C0003
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 10:57:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B+Mfu50Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795085874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nkep9V+9M81dGzA4DVoTUAoMFfZAfhwxu8MxQVdO5n4=;
	b=vaqXMrLui+GPlsDJu01ggxT2weeuG854D78tW1dLsFAj0NDX/4IGW35RjSZ10LkO5QmNoz
	d1LRTQt33hEBERYwlPwcM5V6/im9fe4a0lfr0mIh5Gb/v8x71Ji1fydoKlC1vsSqcZ4er7
	9WUAThZ8IVNRweVJ1yQZz+RT0gRxvgU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=B+Mfu50Z;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf22.hostedemail.com: domain of ridong.chen@linux.dev designates 91.218.175.222 as permitted sender) smtp.mailfrom=ridong.chen@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795085874;
	b=lz66R9cScQLm/tCsDvUtla99/zi+2tFSHbvUgozyNEYUnq39ed8eczy98C2PZedSiy9LNz
	VI11eKYjn5Lp+XgNMY7hpp86K5lUjJude+jiPDU2kASLUlf7US3zdRPUyGzUJK5QD1k84F
	Jrwd6em+u5g7oeWJyy3wyvPhHNddenY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NEZHan1kWUfbBPUsTRpDo31GyAtxZjws+3uudEspXMo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795085872; v=1; x=1795690672;
 b=B+Mfu50Z1lUc65cuVrDJPztWYlRgjPCUnEdUzC3yz15EYrgDUMBUzeTHVt3I8xp0ux5LYg8j
 2wfeFB+VtW6S4P9mwexfDThe+mHv4LCiOVIOnI6kaTEtgmoydy1TxhdqdrGjspc9wyU0qk5AZTp
 SRokNbBU7sXYBuL73OOxgbGU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id d39bc78d310ad665;
	Thu, 19 Nov 2026 10:57:52 +0000
X-Mizu-Trace-ID: d39bc78d310ad665
X-Migadu-Flow: FLOW_OUT
Message-ID: <c86a3b79-353d-48b8-ac7d-eb87920feb66@linux.dev>
Date: Thu, 19 Nov 2026 18:57:40 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 08/16] mm/mglru: lift youngest gen protection for
 higher priority
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
 <20261114200803.23129-9-baohua@kernel.org>
From: Ridong Chen <ridong.chen@linux.dev>
In-Reply-To: <20261114200803.23129-9-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zr1s9ka8w7j1o7jjmtbbp5uch8zhjri9
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3EC64C0003
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-HE-Tag: 1795085874-645472
X-HE-Meta: U2FsdGVkX19sBXov1JIDZMMdcQNt52cVPTTgeVSmcwYoFAAlEX/XdaelN6jGxeXBtV/bu8pGTlE6C38yZdNb3+Bfyb0T4PNJM4ftC1qe1YZnOmNujGbVd+mUDVEXuyLacEoUaKj0aSv2en9vpBYd5zCBYKS7/MPOQPIEaAgUUGEa/pCMqSYklByY32CHCshjrZwe3MXpuDNZHYOleusiM7ETTqDTXL/hSrRizwkCgDGafzpT/CBclP3Vy5TQwgkIOkxFARnalN2oRDlzziEgekpbACB9kfeiy3l4PfctlI4I1ryB2g4SVO6rh1YIcyKPqrga6I3HnFqw70KlqlTL1fxFDc0QQDQAGENZ7ncTD1uqrvi98RG3rEXRGSV6dcccLR+3QSkgK2YzeUUSjFxECtmFmzwU63OC30XYL/gZRrmIWfigy5lDbE6/DarHxfNi+9kC3VuDsS39/EKiBY9TvVhG5HM9/0oGYOsi1RBfJMqQ9ibtPGQPmlp+Jkz1wuq67YJwWJx4Qq9gFuW1gNV5UfQ8dKkxbj3/7RpQDMQ7W3u3kGh0eHoyAWLOFmSDaib606izgbcqwdfBFbjUBLAvJ/Gr3eV0i7eA536nhGrSxgSSS3+x4yiXC400a8ev1A2lE0i2uJKfp8kN1LhTDqFvqatszYwt+qPs9tP7MrSlDaKwL6q1Hm9qT3N13YnKaY0wDZdkBo9LRzmPo7vCgkAqn84be34lFDcyAXHoW01OUnqyN+W2xJ/ITRlVNOk2ACcAZBgVMoxxhEJb03HxDH6PzTnLW/jv57VKeJyyX/2TsvPhaQRTbmbHk0UOAM6LJsXyhCxep9HTRIy9mvFOZPdiN5xAEkEWZn2/lvUJsovCJeV1ixYkHQ2aIsUTdNzCJSW24edl3bHnxmGXkTiJwsIH1yiXxzIfUgiEo5sv8zcANmkHyX0Tl64XTGfh/hCfPZHKHTWlcW/E+WyqmOtyyNG
 LrYsv06O
 fr7wq/d5ys4v/b1CDl5VNfDzUU3qo0lTL+qpRsGIELPNXVzboViFl44YRSW5ubwSahyk8pdoIPs8C3oGvtkjyJ1prQVKxvWPlEmjObxBcArhc53XCg4gAjSQIRcvDvRGmgCwiZiqbIk/LBiR4l2SOeesrRW45vvXUQHZgjVyCxcKUaVu/HU/Rb+A1vYJ3pGQ+X6L7NYUM1tphsmtZaW3rMjqBq9YhyfC8RIcEqGdXD7m7XE1bnq2Rdq5T1D/lYWbofGM0RGNLKc4VX70TBQbJ4UlNP8s3W0nQbogtDKam7/D8DzwphNsJvPeEyBQW8u+8zOFdtlkgLSCLdfc/IuF79yI4I6zn6PAGFLXi3ufc/FupI4jLVQU1/gZQsDf7u3L1o3QpnLjo12Kjo4b0oYoTi+vlpbO7aUV6zNwRh5VBIc8CPr8=
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
> The forced protection of younger generations contradicts the
> goal of minimizing the I/O cost of reclaim. Under high memory
> pressure, MGLRU can repeatedly trigger premature OOMs, while
> the classic LRU does not.
> The problem is that aging may fail to keep up with reclaim.
> When this happens, reclaimers may all abort prematurely
> because they see only empty generations or just two
> generations remaining.
> Proactive aging does not solve this problem either. The
> number of threads performing proactive aging is limited,
> while the number of concurrent reclaimers can be much
> larger. This is a fundamental limitation of MGLRU. One
> possible solution is to use an aging lock. However, the
> aging lock introduces significant jitter under heavy memory
> pressure and has been reported to cause noticeable lags
> on Android.
> Furthermore, the generation-based reclaim model can
> conflict with the goal of swappiness, which is to minimize
> I/O cost rather than blindly follow folio hotness.
> The previous commit allowed reclaimers running at
> non-default priorities to reclaim up to `lrugen->max_seq`,
> while reclaimers at the default priority could reclaim only
> up to `lrugen->min_seq`.
> This patch further refines generation protection based on
> reclaim priority. At the default priority, reclaimers can
> reclaim generations down to `lrugen->max_seq - MIN_NR_GENS`.
> As reclaim priority increases, reclaimers are progressively
> allowed to reclaim younger generations.
> With this graduated protection, premature OOMs are no
> longer observed, while swappiness is also respected.
> 
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> ---
>   mm/vmscan.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 18cf1c084e78..b538abf02578 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -4772,12 +4772,14 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
>   	VM_WARN_ON_ONCE(!list_empty(list));
>   
>   	/*
> -	 * Respect the gen hotness distribution at low priority to avoid
> -	 * aging and scan cost, but prefer to satisfy the reclaimers request
> -	 * when under pressure to respect swappiness more and reduce IO cost.
> +	 * Respect hotness at default priority, and only reach into the
> +	 * newest generation when under severe pressure, so hot folios are
> +	 * not evicted as soon as priority is raised.
>   	 */
>   	if (sc->priority == DEF_PRIORITY)
> -		seq = lrugen->min_seq[type];
> +		seq = lrugen->max_seq - MIN_NR_GENS;
> +	else if (sc->priority > DEF_PRIORITY / 2)
> +		seq = lrugen->max_seq - 1;
>   	else
>   		seq = lrugen->max_seq;
>   

Reasonable.

Reviewed-by: Ridong Chen <ridong.chen@linux.dev>
Thanks.

-- 
Best regards
Ridong


