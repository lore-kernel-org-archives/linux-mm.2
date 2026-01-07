Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A1B7D0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 22:11:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 096D16B0092; Wed,  7 Jan 2026 17:11:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0426C6B0093; Wed,  7 Jan 2026 17:11:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E66EE6B0095; Wed,  7 Jan 2026 17:11:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D46B86B0092
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 17:11:02 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A30731B848
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:11:02 +0000 (UTC)
X-FDA: 84306563964.25.BF309D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id B7D344000B
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 22:11:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r1+tHxq9;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767823860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ka1ScSk38mA1fQo+yrbPZPrURX90zxl66ux7yCgNOm8=;
	b=rjZumOeyiyh6Fsw5X0di9AEyuenFTZtP4hAAnc91+t92udTwAXdiUIqdUsatnenjD5eiZo
	WMAyeGjPUgXFdheqtduNpad/seufg2PcsOJRMFjerhptSymibT/PE1ff5Cga49dATNhzV8
	q5wzzdeOKigkVycAa6VclSetQiHTQDo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=r1+tHxq9;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767823860; a=rsa-sha256;
	cv=none;
	b=HLkV2j8njo5PYf/wXVRE3beC8kGXTwlb09X+LemcTyvNgaZHT80oZGiYWxMZLXkiibGY3Y
	3e/rFUyslJVWYbD/I8fLfBQCkqvoGoixy8HvKQqhdZIpZXJjB/olTlhsv2b1WvrKJ516BZ
	djksteJbiQU+Ml9JYUPfsC2tHMW95Ho=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C62CE4328A;
	Wed,  7 Jan 2026 22:10:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DF4DC4CEF1;
	Wed,  7 Jan 2026 22:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767823859;
	bh=+vXdLzxmfnTJBI30YS7jqs6X6r/7IlLvDsrcNG7TAL8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=r1+tHxq9P0qHgFDrAAaRKsjj0Ykezt7Mg+D6Be0PoYSOJ5LOPWtbQsXYg/rJQXswp
	 d5yE7UZ0N6FTPY2x/7OcvEvYH0TgKo8iE4lKRvB7kvNS95nUD8jix/IEwKfL59zk8n
	 flevtrQXhT+zBjQFGMifKdJIEnhTJcn2z7Hd8qfh+uzTbEkpWUOnJ7oLdpZcPpxp1M
	 N4MXxIR1xItoqd269Vr4vuiOfbmOx9x4Vo2nIyJgG1XHd1JZ6Us9m+UJmAMoLNv9zc
	 pbEjU95rutp/ucZGkCpQ6XoaAajXuZ08i9Gkv2GHAHac9CEeJYR05ikBEDwtXQvyHZ
	 g7W8oWxA87Crw==
Message-ID: <2dc62426-f04d-4a40-98a7-e59965abecb8@kernel.org>
Date: Wed, 7 Jan 2026 23:10:51 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 6/8] mm: folio_zero_user: clear pages sequentially
To: Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, chleroy@kernel.org, ioworker0@gmail.com,
 lizhe.67@bytedance.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20260107072009.1615991-1-ankur.a.arora@oracle.com>
 <20260107072009.1615991-7-ankur.a.arora@oracle.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107072009.1615991-7-ankur.a.arora@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: B7D344000B
X-Stat-Signature: iqq5ptw95majxwkwxdbmahbjc7kftub8
X-Rspam-User: 
X-HE-Tag: 1767823860-282732
X-HE-Meta: U2FsdGVkX1/V9yTsqjYQ5u7jmyhbJga9hRwH2BFV9LUCDBHfhNZ9lcXjEH5bz4m7HEQepRx2tT3MYGsD8rZ41ylGIKVMNBE+7IiUFsOen1RwmhfU4w2PivDI9BbdxPxKZm2MzxndlGgrhOdRf1u9N8gHsSzf6RFk4xmESjQmHnT7i7dYjqreak3CSnWZkNfFwyGuUNw6hEt7s3eAAGqsxmsIiFB3Z32YpjsNAxl6vefUG37QsxPIgyPHMESn4A6jrQM20uXlsfYzrWWDW4/AiPZeRAMwAN10wX+9nkC6L4akv3XPGeTF5xlovJd65OZXX4Hkylw5CYUP5gdN66CPVkjFzWm+E6PH3pRiMMMpJjNdv58zsFH5Q25lQ0LZgIemNbGkaiofYMNq+grDmaO3l17S2CKCCYcdDDGdV2NvgTkpRuHRhsuHB8bjUxR70PzDf8qHvqamkXYZcvv6nrts6E8PIUdAbsL+U+VL5F7/mR0+A5YzHlvAwSFvEvWYCMHqoKD2m8EPuwx2aEw2rpTsAwa91TjGy2QQCf9MV/rHlvCdSCa5A2hUIkCpkwPTnu0c+Lqhhk54I6jF7W5wDXuuKUYkATexIOc38m1P9qGxnWn/7SkCHuEdf/X9a2I0dcM4OJ60OExa0BdPlLt/XrkF6zFrGA6fXH9woVqA91JaIan0BNiWpJe+Zk5Q+Itqj2wWTAAn+78goeBdXfNHAKRu2gR4sgxxCruB3AmuoD+o0QnTlD4cbCPjFVJylajQrRzD5cVaJvo/58I4Mh2lIQpfBY2Plbvhg1UXuCnUIB+CTIO9kICOccUWG45GH+crq6j41TxjkKsZxDIqwysBzSdI7EzZf0jnyQAt3wxtDoedM3nqxZg986myTSNEEnMG0kSnXxiK859OoIYF3CIvgNry11MWYW1Je6uSmq4Ysj3e56zgk/sv2KV9ch0KPZ6vxYDCbNnabGXhCgxkD+s13PI
 J8f/lk/+
 6no9/iRMQm8qHj5nkWdY6BkevIeHGqz15Dkt/xbL/AeuM0tGxhCltJL/kKtsWq0Kh3xOYER3RE5Cw/suD/koFMFydWtNtFz8m+y6xBWOCx4OdPCLSZllIAzW1YjG9U68eJmY5KkpvojzrTA9bNmadNcLdtRdQJhRSD+HHh1OxA4+L3IJGzuvHoAFbgmrw2/IrV9qZl9nEmOEXJ6opsc1tBJ4ZJaX4P7PByD26SPn2kB1W12dSBfR0qMcyK74aiDg3vA4f0sunGHI1xDhww5PNzzOY0za5MaUpm99YqFfQ1rmQkns1VjJz36CNzhyBpr6Y9vCd+F5amM4EGsBnUEk4v/ymU7onbNfGmI58RSyRqxV0DWYHDbyQaqCwksCHDjnjeq/k
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 08:20, Ankur Arora wrote:
> process_huge_pages(), used to clear hugepages, is optimized for cache
> locality. In particular it processes a hugepage in 4KB page units and
> in a difficult to predict order: clearing pages in the periphery in a
> backwards or forwards direction, then converging inwards to the
> faulting page (or page specified via base_addr.)
> 
> This helps maximize temporal locality at time of access. However, while
> it keeps stores inside a 4KB page sequential, pages are ordered
> semi-randomly in a way that is not easy for the processor to predict.
> 
> This limits the clearing bandwidth to what's available in a 4KB page.
> 
> Consider the baseline bandwidth:
> 
>    $ perf bench mem mmap -p 2MB -f populate -s 64GB -l 3
>    # Running 'mem/mmap' benchmark:
>    # function 'populate' (Eagerly populated mmap())
>    # Copying 64GB bytes ...
> 
>        11.791097 GB/sec
> 
>    (Unless otherwise noted, all numbers are on AMD Genoa (EPYC 9J13);
>     region-size=64GB, local node; 2.56 GHz, boost=0.)
> 
> 11.79 GBps amounts to around 323ns/4KB. With memory access latency
> of ~100ns, that doesn't leave much time to help from, say, hardware
> prefetchers.
> 
> (Note that since this is a purely write workload, it's reasonable
>   to assume that the processor does not need to prefetch any cachelines.
> 
>   However, for a processor to skip the prefetch, it would need to look
>   at the access pattern, and see that full cachelines were being written.
>   This might be easily visible if clear_page() was using, say x86 string
>   instructions; less so if it were using a store loop. In any case, the
>   existence of these kind predictors or appropriately helpful threshold
>   values is implementation specific.
> 
>   Additionally, even when the processor can skip the prefetch, coherence
>   protocols will still need to establish exclusive ownership
>   necessitating communication with remote caches.)
> 
> With that, the change is quite straight-forward. Instead of clearing
> pages discontiguously, clear contiguously: switch to a loop around
> clear_user_highpage().
> 
> Performance
> ==
> 
> Testing a demand fault workload shows a decent improvement in bandwidth
> with pg-sz=2MB. Performance of pg-sz=1GB does not change because it
> has always used straight clearing.
> 
>   $ perf bench mem mmap -p $pg-sz -f demand -s 64GB -l 5
> 
>                   discontiguous-pages    contiguous-pages
> 		      (baseline)
> 
>                     (GBps +- %stdev)      (GBps +- %stdev)
> 
>     pg-sz=2MB       11.76 +- 1.10%        23.58 +- 1.95%       +100.51%
>     pg-sz=1GB       24.85 +- 2.41%        25.40 +- 1.33%          -
> 
> Analysis (pg-sz=2MB)
> ==
> 
> At L1 data cache level, nothing changes. The processor continues to
> access the same number of cachelines, allocating and missing them
> as it writes to them.
> 
>   discontiguous-pages    7,394,341,051      L1-dcache-loads                  #  445.172 M/sec                       ( +-  0.04% )  (35.73%)
>                          3,292,247,227      L1-dcache-load-misses            #   44.52% of all L1-dcache accesses   ( +-  0.01% )  (35.73%)
> 
>      contiguous-pages    7,205,105,282      L1-dcache-loads                  #  861.895 M/sec                       ( +-  0.02% )  (35.75%)
>                          3,241,584,535      L1-dcache-load-misses            #   44.99% of all L1-dcache accesses   ( +-  0.00% )  (35.74%)
> 
> The L2 prefetcher, however, is now able to prefetch ~22% more cachelines
> (L2 prefetch miss rate also goes up significantly showing that we are
> backend limited):
> 
>   discontiguous-pages    2,835,860,245      l2_pf_hit_l2.all                 #  170.242 M/sec                       ( +-  0.12% )  (15.65%)
>      contiguous-pages    3,472,055,269      l2_pf_hit_l2.all                 #  411.319 M/sec                       ( +-  0.62% )  (15.67%)
> 
> That sill leaves a large gap between the ~22% improvement in prefetch
> and the ~100% improvement in bandwidth but better prefetching seems to
> streamline the traffic well enough that most of the data starts comes
> from the L2 leading to substantially fewer cache-misses at the LLC:
> 
>   discontiguous-pages    8,493,499,137      cache-references                 #  511.416 M/sec                       ( +-  0.15% )  (50.01%)
>                            930,501,344      cache-misses                     #   10.96% of all cache refs           ( +-  0.52% )  (50.01%)
> 
>      contiguous-pages    9,421,926,416      cache-references                 #    1.120 G/sec                       ( +-  0.09% )  (50.02%)
>                             68,787,247      cache-misses                     #    0.73% of all cache refs           ( +-  0.15% )  (50.03%)
> 
> In addition, there are a few minor frontend optimizations: clear_pages()
> on x86 is now fully inlined, so we don't have a CALL/RET pair (which
> isn't free when using RETHUNK speculative execution mitigation as we
> do on my test system.) The loop in clear_contig_highpages() is also
> easier to predict (especially when handling faults) as compared to
> that in process_huge_pages().
> 
>    discontiguous-pages       980,014,411      branches                         #   59.005 M/sec                       (31.26%)
>    discontiguous-pages       180,897,177      branch-misses                    #   18.46% of all branches             (31.26%)
> 
>       contiguous-pages       515,630,550      branches                         #   62.654 M/sec                       (31.27%)
>       contiguous-pages        78,039,496      branch-misses                    #   15.13% of all branches             (31.28%)
> 
> Note that although clearing contiguously is easier to optimize for the
> processor, it does not, sadly, mean that the processor will necessarily
> take advantage of it. For instance this change does not result in any
> improvement in my tests on Intel Icelakex (Oracle X9), or on ARM64
> Neoverse-N1 (Ampere Altra).
> 
> Signed-off-by: Ankur Arora <ankur.a.arora@oracle.com>
> Reviewed-by: Raghavendra K T <raghavendra.kt@amd.com>
> Tested-by: Raghavendra K T <raghavendra.kt@amd.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

