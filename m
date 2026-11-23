Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E4E5606A31F
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 06:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=i/VbpO73
Received: by kanga.kvack.org (Postfix)
	id 9D37C6B05B3; Mon, 23 Nov 2026 01:14:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 984086B05B4; Mon, 23 Nov 2026 01:14:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872A56B05B5; Mon, 23 Nov 2026 01:14:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B4F26B05B3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 01:14:22 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id ECD181A07A7
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:14:21 +0000 (UTC)
X-FDA: 85465369122.27.17A3111
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6A1B64000D
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 06:14:18 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/VbpO73";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795414458;
	b=H9ZVTR8rxCDIIauy7b1EvmFRmA7hKB1bp0PUTCqxewcgQNjatVVaVMkV7ioKCIOe01LldA
	DBZKlRoQ/h0DQJJzOB2zwq2URLHE4aEqUXAecDWs0hF4QgKhgqsrM0HvRY+n+wltUAkUv7
	p4odwCuqCWkBt7P54Dcpgwp28s+7vFg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795414458;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SHhqxyIvi1H8U2rpd4aCXqvgpSyP2JDBne5lwDZqiDA=;
	b=H+Pd5f9UNz5o/0HCw3PFecjjcD2xtP7/OgLAf2IOuhkdh6lBKddROctUhHfUQvOId64ka5
	191mz4lZ5oSYUsTRog7c9LAoPLzXq9xdZBqIiU6Gmt8RPU5uTVFm4+S6TBQsKXne9uOTDe
	PBceaF+okqnN2VxIjhduNpJA3+TRzPU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="i/VbpO73";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=8leuJkCR02HJkwbVtT7h+Y6uZAx1n0OSx/Rh8/dbJII=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795414454; v=1; x=1796019254;
 b=i/VbpO73YPgCx/M9LcFeekAOXziWLmth0/Wohodwa4gJorzoO7dRmGN3mxbqFurtSLJfCt28
 bWs+XF1pU4aiAp41r2mlVqo4iAeRfxqo0f35GqzuqfrbOT3gohmEily4CRtcvqZZ0pT0VVUG7vi
 5+G0IVd/U0Hn+i8oufECMbdY=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 3a93840281764757;
	Mon, 23 Nov 2026 06:14:13 +0000
X-Mizu-Trace-ID: 3a93840281764757
X-Migadu-Flow: FLOW_OUT
Message-ID: <00efba16-87da-4fb1-8da9-2fe554a6eed9@linux.dev>
Date: Mon, 23 Nov 2026 14:14:06 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: shrinker: stop counting when the seq buffer
 overflows
To: Xuewen Wang <wangxuewen_ky@163.com>, akpm@linux-foundation.org,
 david@fromorbit.com, roman.gushchin@linux.dev, muchun.song@linux.dev
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Xuewen Wang <wangxuewen@kylinos.cn>
References: <20261123055020.287151-1-wangxuewen_ky@163.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <20261123055020.287151-1-wangxuewen_ky@163.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6A1B64000D
X-Stat-Signature: fi8g13mrwgjq9x3mfauawqocfzie8t5t
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795414458-141698
X-HE-Meta: U2FsdGVkX19lZ6gqgLNGjtELiXdpk9ppJ90vQLdl/2nvlT6Z9XrSCNMNs7frIU+56YPxcitYWrSfsAyr9WuPi6f9Q9Y2+DuNqcYn/AlR6yNKqQDtZXLhZy22/zPAWvBRw5uWvxQT3Xy1Ex9zHPDKSWGVS/kESHNXM24atm5RJ+NRob+y3NkU86kiYbsVtYMaWDM8p9vzYnSbKEqOEsaJrrfVTVukpy1V9xfcSUpwgcisanrBbQQTtX8Y8mt49MmMRklOBa8WhWTUUqJodR1sRP21xyMzNc7W+M4x5vPtU8ogu+vMg8OH8UEsS7e8IELxPH4JCEv4Pe6VuFqnZ2nWDhjlA4v5eQwBsYy47urgZ/VsX51hBRcY5X9+0fhJoIGrdyeKm7FqacSsdf/kOsIsYgFoA5xUDvbj9JTCRMxLxLzfLnsWOa6OmC6E4FWcFjpCx/xTugoQo605eqeri8c0taLe6MTITUj2peFGDSOQhopG6zjR2TRXFgyI386u5kSSBKTvg6Bh7nNZALoYz2n6JjbbVK23fl2B5cmI8G/0CBPjw/mQeeliWOAGGto2Pk4bpJu3Zvc8+uVa6oA4LcdFvuQxg3Yw8yxypUjuGhjs5MawsbJLLi4TgIOAHI8ds6I+B6L9/pg9tEHiDP0h86MTJufeDMLzx1+5flW6k8L4UzrW060cU9WR9yU25Uq028u+wQWIcHCDjMSLb6c7w7G3VW9Swcywzp/GnaXheHrAaA7VLOiUiwnHCvUYAOxKQY242XTR68WWCu3ODfd06ZMIm0UKCaAQZjlEn9LV7XOUFmOdlzqbM+Jhr9gQYKmk+wmKMAppcCAAkw7P45yKfnSD1G8fdiHqpRId37nuVja/D6lNrTanJ7OjZS4lGaD1oU2p8ro3SPVMnBPOeEI5THhxSRz3J0w+5A+4foldO2dBv/lFytES3VeiM0X2yuIkosmFx1mTcujPecv/sTh4L98
 ScQzW7Ij
 LLonec8XxInyZFhJn46cLFgB6vcJwJLmC/hMvOfbz6LNokThoIX7AqljB8LWvNnqKDN0doWQimI5MOoGHzdT5OiFsyDzbC8J5gaeFiYcoHBn9rlEqTLP6D+sq6W1hWzWjcWeHkLXqmTYkSR02LCWwowRYs2pmrihBtkKiDaisxgX5mL9mcRloiCevjNQt/6hwNHdaEge2W0qm77UCYbdrLOeHfOq+/Fm9JHTqD3xDehKojv14il5fOhlpMB44MS05Zlb7//5VVNcZljC+shk538S+TleBTlwIA6915e9tIXRB/bcKvFyxgyGVSpEstFQVmk33xffaE3TqhVs7ombkSy/hx8p4p5k6gb85A/cTfPzLZIem9ZAE4+zWiHM7WSrY57qIA8zwuGtNuQl+EiDhZuISdGvUiBXPlZbT0XEhhb5W/LLkp2iqIHfpsm/atHsJpSMABqB2ChahFtMat/TjXE4hFt5hi7nrKKSei01Iz0ZvIpY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/23/26 1:50 PM, Xuewen Wang wrote:
> From: Xuewen Wang <wangxuewen@kylinos.cn>
> 
> The shrinker debugfs count file uses single_open(), so all memcg rows
> belong to one seq_file record. When the buffer overflows, seq_file grows
> it and retries the entire record. Queries for subsequent memcgs in
> an overflowing pass cannot contribute to the final output.
> 
> Stop the traversal once seq_has_overflowed() is true, using the existing
> mem_cgroup_iter_break() path to release the current memcg reference.
> Check for pending signals first to preserve the existing -EINTR
> priority. Leave the overflow state intact and return zero on overflow
> so seq_file can grow the buffer and retry.
> 
> Signed-off-by: Xuewen Wang <wangxuewen@kylinos.cn>
> ---
> Changes in v2:
> - Move the overflow check after signal_pending(), as suggested by Qi
>    Zheng, preserving the original -EINTR priority.
> 
> Retested in a single-node KVM guest with 1024 cgroups each caching 16
> ordinary files on ext4. Output remained 8865 bytes with three show
> attempts. Count callbacks fell from 3075 to 2472 (19.6%). Six fresh
> guests per variant each performed 101 full reads with no probes
> registered. The median of guest medians fell from 127.8 us to 114.0 us
> (10.7%, about 13.7 us per read).
> 
> Output matched byte-for-byte across the tested guests. Small reads,
> seek-to-zero rereads, populated memcg teardown and signal stress passed.
> Separate probe runs had no missed or dropped events. Small/sparse cases
> had unchanged callbacks. The 64-cgroup baseline timings were bimodal,
> so their apparent timing difference is not attributed to this change.
> 
>   mm/shrinker_debug.c | 5 +++++
>   1 file changed, 5 insertions(+)

LGTM, so:

Reviewed-by: Qi Zheng <qi.zheng@linux.dev>

Thanks,
Qi

> 
> diff --git a/mm/shrinker_debug.c b/mm/shrinker_debug.c
> index cafb566301326..eabdb33353a45 100644
> --- a/mm/shrinker_debug.c
> +++ b/mm/shrinker_debug.c
> @@ -84,6 +84,11 @@ static int shrinker_debugfs_count_show(struct seq_file *m, void *v)
>   			ret = -EINTR;
>   			break;
>   		}
> +
> +		if (seq_has_overflowed(m)) {
> +			mem_cgroup_iter_break(NULL, memcg);
> +			break;
> +		}
>   	} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
>   
>   	kfree(count_per_node);
> 


