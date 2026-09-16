Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35E49C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:22:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513FA6B00A9; Wed, 16 Sep 2026 06:22:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EBA26B00AA; Wed, 16 Sep 2026 06:22:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 429AB6B00AB; Wed, 16 Sep 2026 06:22:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 245906B00A9
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:22:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B447A14069F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:22:51 +0000 (UTC)
X-FDA: 85219236942.26.A346E36
Received: from mta0.migadu.com (out-175.mta0.migadu.com [91.218.175.175])
	by imf31.hostedemail.com (Postfix) with ESMTP id 722CB20003
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:22:49 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y+QNkmNS;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t8i0LXdk5qjkZdMQm5F1CAFohDI7OIZ1S+nddO26KQI=;
	b=gPLAVwl4ydPZ0LSbQlS5BAneJ31EjMZwfoL8jFOHnHdHNZzQYASf7BVxMxEj0bpzn/5wyI
	zx5osft9QjtBKPFLfd5VSwMfsclxJFTWTtVP51ftBcZGXf2UgsXbAZj5bV/P56RYydMkql
	3jp1fbKUozeZF9Od482SjpOncXEDmTw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554169;
	b=k5i+l8D+72x6mBOyON2eD/7e0k0GqzTbsdGjEDf/CrHa3ENR+swbnzd2IC5yxrAkUVPDzV
	6jvmdd47wadW4wtNEf+htopWk31hQkn7wVtjg9QWEDC8qDdlZQiIQSu+Mb14ZoDRf87s7c
	bYyOSr13T/EBIMehuCegjiNj0UaG5U4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Y+QNkmNS;
	spf=pass (imf31.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.175 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PT4zk2r1uBSOi61HrDnCALYdUMVvyDSIHnzcu3tFfUY=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789554168; v=1; x=1790158968;
 b=Y+QNkmNSQkBNQZUOK5mdRaepomyjNARR7qgsuJBWKzjTyCv5bziMJRQLw/gM1Pp8h6SW+EfR
 TXUCbAdLswbJHmVr4aIxcdvahIBoSXKy0BmU177uN+aA67mkr0JVRUt5HlnBziItM4Mb2O+0Vld
 44LeG8sih3IPQh7bg1+3FAlw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 6d5276e9e29299c1;
	Wed, 16 Sep 2026 10:22:48 +0000
X-Mizu-Trace-ID: 6d5276e9e29299c1
X-Migadu-Flow: FLOW_OUT
Message-ID: <7666a248-4411-419f-a2ce-42a71a51126a@linux.dev>
Date: Wed, 16 Sep 2026 11:22:45 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RESEND v7 00/29] mm: PMD-level swap entries for anonymous THPs
To: Andrew Morton <akpm@linux-foundation.org>
Cc: david@kernel.org, chrisl@kernel.org, kasong@tencent.com, ljs@kernel.org,
 ziy@nvidia.com, linux-mm@kvack.org, ying.huang@linux.alibaba.com,
 Baoquan He <baoquan.he@linux.dev>, willy@infradead.org,
 youngjun.park@lge.com, hannes@cmpxchg.org, riel@surriel.com,
 shakeel.butt@linux.dev, alex@ghiti.fr, kas@kernel.org, baohua@kernel.org,
 dev.jain@arm.com, baolin.wang@linux.alibaba.com,
 Nico Pache <nico.pache@linux.dev>, "Liam R. Howlett" <liam@infradead.org>,
 ryan.roberts@arm.com, Vlastimil Babka <vbabka@kernel.org>,
 lance.yang@linux.dev, linux-kernel@vger.kernel.org, nphamcs@gmail.com,
 shikemeng@huaweicloud.com, yosry@kernel.org, qi.zheng@linux.dev,
 luizcap@redhat.com, kernel-team@meta.com
References: <20260914122950.3283997-1-usama.arif@linux.dev>
 <20260914203237.7cdfcd4c320470f4ae5cafd2@linux-foundation.org>
 <ae847e8a-8c16-4170-a18c-19adb1a50de2@linux.dev>
 <20260915170010.0667b6dee268fb6fb29a3fee@linux-foundation.org>
Content-Language: en-US
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260915170010.0667b6dee268fb6fb29a3fee@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nhhmrwfg9k69qwt8qd1eaczm8c3z9rse
X-Rspam-User: 
X-Rspamd-Queue-Id: 722CB20003
X-Rspamd-Server: rspam03
X-HE-Tag: 1789554169-764769
X-HE-Meta: U2FsdGVkX1/Pf2OyBUL081KIHCeTTtqcnqw7TqTGIXahOi8f7/v6hpNSUP15SQOcFBK2Fj6WqXzoa2tWEsQzyccdXbWUsNqLxnwuLQNKN+C4xL54nHlm1vFkSRauHpTkyKlov+/n1nstYmr29W4CpoADGgDmz6zZxyerc0IRuVT3tDn3NonorGjrbGlkEW/YhS2y16AUqdKbEpfdz1OVO0SFcwN+1a9Ifzdxour6wxQFhwSdvwB1bP6OdJFcsXQekbRCzal5e0KBQRlAZr2t+RnfqlZo/c2gOcWZ8BseXA4Jf+nzSsgT6vGkQxZlz2szjHuyWfprm+aT8YWCY24ScxRdksd8x+lUjQClkrTJDQGxMY87rOuHk7zTZI2GznV9f1aHy6XehY2Ywq7YCGpt6fhqqBKTt33nSXD8+hwTf/YBymZPHwOpb4EVg8qRhwxlUmqp9NScfrV9N3MYhk5hEJWoiD4kJybW0lgheKYtu7IAJZaT7Un/zO+F7gtdVS4u6Buv+h5rMk6hqVlPD4DkcxVY6Zeq5r4w2yIuhewipzio7V/Eiqh/GHZvtp15mp2SBV6AOXhmqdngZPwILG9dv3bN8fzX8JsiRtH5IF8kwe9LD0+rJcVISz895I++8in7/r8/BEmVw9g+1zHK2TaQJ4hEiaFrJMwO0UiaaCg+gzwgSoOUGWlkleZ4f4T/NgpaU6R180TvRv35ZxUoq6cHjg/a8ud7as7dGZgsHodGjbzovMaj2NtQlFMcSQRp1bC0q+p1S2iHfRDZfAlO81ZMHb0jlfr00aLOsIiHfibFYbNsM0Axdeac1ctSVpFBRmgmXlG1zpfvHysiKt4nc5XPJzFUo3fitGG/8zsJ10Vrg6PDA1flrQAcQIkQae1qPN8ujnSCFS2NLVFYZDXqbi2TS7BKg16YpRO6lVWhDRDWq7vWz/ky68pfHllMCqQAkGILR6CPzvrlktUh1s41abI
 cMAzbAOT
 ivicysgLM4cPUoxBJ23sXd9V/YOGhI4Kv96VyhO9pV1C/+k2YYoEIwSdGs38QXBRiR21ivj+uvNgmOSN0tfSfDR5HS80O/377UVVeZCF8tTJ8UZPWJGa2IvY442vLs0/9+gSXmHr6LN17duwbE2Ee8X8F9/hrPatoiNQTDGhPCqrbQ74SOmTnMVTrq0pixegRH/DcaLK/agB1vcURQZCinDYZFMsriKSracqbpbGkx9o2TD9DlnnHCVAIN+cd1IR4EzqsoZPovog8+o8emptUyIS3MA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 16/09/2026 01:00, Andrew Morton wrote:
> On Tue, 15 Sep 2026 15:09:16 +0100 Usama Arif <usama.arif@linux.dev> wrote:
> 
>>
>> Four workers repeatedly write the working set, forcing memory to be
>> swapped out and back in. The results below are the medians of five
>> interleaved runs per kernel, following one warm-up run:
>>
>> Metric                           Baseline median   Patched median   Change
>> Aggregate benchmark throughput   584.3 MiB/s       2,408.9 MiB/s    +312.2% (4.12x)
>> Elapsed time                     85.43 s           20.72 s          -75.7%
>> Major faults                     1,814,699         228,466          -87.4%
>> Swap I/O rate                    1.02 GiB/s        4.10 GiB/s       +303.9%
>>
>> The results look good as this is a swap-intensive workload.
>> It primarily demonstrates the reduction in swap-fault and page-table
>> overhead from preserving PMD mappings.
>>
>> For long-running workloads, where I believe the series will shine, I expect
>> benefits from fewer TLB misses, less khugepaged work as well as less kernel churn
>> due to larger folios, although there aren't a lot of benchmarks to test that.
>> PMD swap entries also move us closer to eliminating page-table deposits for
>> anonymous THPs, which would provide memory savings.
>>
> 
> Thanks.  Wow.
> 
> This doesn't look totally real-world but it's close enough to indicate
> that real people doing real things will see nice benefits from this
> change.  As expected - leaving post-swapin thp reassembly to khugepaged
> was so lame.
> 

Yes, exactly! I initially left it out because case-swap-w-seq is a
swap-intensive synthetic workload and might not be a representative
application benchmark. Completely agree that lower reliance on
khugepaged will be a much bigger impact of this series. Unfortunately
I cant find any benchmark that would capture the affect of that.

> Please add the above info to the [0/N] and maintain it.
> 

Will do!

> (I'm itching to get this moving ahead, but we do need eyes on those
> core bits).

Thanks for helping move this forward!

