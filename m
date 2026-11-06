Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 839C6606A33A
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 23:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O+UuiM0f
Received: by kanga.kvack.org (Postfix)
	id 911B76B05B1; Fri,  6 Nov 2026 18:59:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3696B05B7; Fri,  6 Nov 2026 18:59:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B20A6B05B8; Fri,  6 Nov 2026 18:59:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 48FBD6B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 18:59:54 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA89F1201E3
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:59:53 +0000 (UTC)
X-FDA: 85406364666.15.CD0E8ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 3C133C0003
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 23:59:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+UuiM0f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794009592;
	b=0qZqyUqPkTqijDq3LrZaSQg1MzA9TRUsclVsQ2lMpNtObHWZflKYUUEa/cLK4dyEw6jfce
	6xNsUsFfxX1h4zasebXGbuoJQdvRGJcTIFPJ56ft+UP0fwzU2+Pjl5T13Qae2LWAxrMSSJ
	IiA/SjL3Ve4NszLSYj0s+Jpx00+QpEc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794009592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kSvS5npMsYGUescqYNHuwns+vY8BLGHpBcdfwZNgI9Y=;
	b=aS6sFHlI7Uo4PjASAcZL6Q7PeNe9/zF+B24+leFQ2cftMGxH3gWmiqRwy+7XShp1CWZOVg
	e+sPDzSVY7uFmD/IlKsVIdjyfkVYVPRRPcCOSotz+Fmym33uI7kZ5rGIAVrEn/nu6CK91g
	Y+r19eIACX1S7a1dScoHlzBAb4Az7rI=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O+UuiM0f;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C5E6E60D09;
	Fri,  6 Nov 2026 23:59:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01B601F0089F;
	Fri,  6 Nov 2026 23:59:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794009591;
	bh=kSvS5npMsYGUescqYNHuwns+vY8BLGHpBcdfwZNgI9Y=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=O+UuiM0fK4oR8EZ2meSl5yH/TC+kEPKIlSb/W1Vwccx2Z1x/oaRBC0rUxhzH3Q1FI
	 wRyLE3mJycmci5fqln5NuoRHSLuj6uxKspkUt30qVSe6ZMLC2t0HcSDa1QCk6rmUKv
	 5/lxEFfmz9oieM+b0kn/ggjdQzHdPIreM/pACSH1F7tXbDeuJH50ISgWKKLkxqOgN5
	 DVti3roP66ChIWz4VIi8l2vpKFLkTPWljvM1kRxcKDPLo7BRWmAUjYmgKQi8KzBLX/
	 9JTm2A0Xd7dQPFJbfWN/sa7XazXvjBwFWbXK2Yf5UM55JxgnYaFUmLkHKXzbUi8eSy
	 MAbKibWYgvpeQ==
Date: Fri, 6 Nov 2026 23:59:49 +0000
From: Yosry Ahmed <yosry@kernel.org>
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, 
	rientjes@google.com, willy@infradead.org, senozhatsky@chromium.org
Subject: Re: [PATCH v3 0/8] Batched zswap_store() framework with compression
 batching.
Message-ID: <au5l3KEjG_mri-br@google.com>
References: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261106072412.7909-1-kanchanapsridhar2026@gmail.com>
X-Rspamd-Queue-Id: 3C133C0003
X-Stat-Signature: uwxndwjapeci5dtammndopn8nbibbeg9
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794009592-521942
X-HE-Meta: U2FsdGVkX190YaJGM4PT/rkIEddAAq2BBsYu1//vSLTmz/+L1z9q66c08gQH9p9kWyy2S+EtmT1Aw5DmjgyyUBe1rOeEE/njwQsZOeFSEPWnsCRvFfLBcGgKGTgskZw9mDuT/vZx9LpqTz1H96VBoJLyoz0nY8ftbBOjDpqN/F0POkdX6JVNfEnmBIiapGtU6f0lL4ljXmVm5e8ORZoho1wGtu/a+w5rsDaxI2gJ2/+/hPsX2onQ8l+SIRmzu9/tfmygpWbf/Tkk1RrKFEnJH2vNXu4iiGxrfSAgVxZwzh57uo0Q7YTfZUh15U+UwJAJ4NyYziVj2F4nxBkzq1pna86pjZWPRlq4thJyL5ddUMRZnXON9CjnFcNlznS8IsksWHCtOLPSjE8979xwsplb/68alUzbwTgmk8g641wAqPJRubjO0Ntyvd6snot4hkGbD+gSvAjAdcjsuE2brwx/A6Cp/YwjUaW5/XTNuo3V+jaNq/E8dHdjH3Fxk8foP/xla/VajAsbfSrBVTY8soxFk/TXEgBPOSWZzWiMXxSW7A3luQXfg7WyPzjzfBeoT3SMgMBkRBAnUwj73woivZxzJyeVHso6/OSvTeSsEUnrxjKADzivy5myFgdPFNAyrV8RScA0CxVPTgddJmHKaqDpOCti6se1RU0QDR2iQaeMR6MZuacb6u2BhAMIr7tupCsliz+8MbzG6Jghuv6BXrg7CT9pPtmWnlD6lzB5XbbwCgHTwluaw5f9ongNX4ytK1K2Wi5sbZav2Px8I25syeYk+SSldD3JV/bYmKOdSSxOsf+iBZ2SyMLk7EtgvMOSumcrQLjKYoqAoseDpunHztJj3QZ1QVVFXJ9iz/DxO77SlchJEh13+EkHzmsBmsyu4N3cpbT5sKVHwhm7QIo4tpfbEacC3eGe1+B3/4HKhmO5KGPzneqB5dTdu/4MujrkCAJhqqW9OOkb1L+ZChHB8ay
 JbPUFnVP
 so6HFifzfPmCtTGwO+79Za5FkFclwCMjIb+2uuw/Jpcu6YYguH+/C8gfMT0qLU602hGSa3Dzv5Cpws49GmDAKAMG7JAV96GUV4Z07j4ELXgXjSZJ8AsfwEN5xu7144V/uVGIs6pH+7hEJFem1akvBY94zQKBcdrlwMx4xzJmq3+Wno8T/eiIN1fMokuuyIRNNAXNsHWrLProZcLRnEPxsRr1yN1NR6MNT07ypwWgsu8zkfjOGf1tzforHSMTtTizcuboKO/g6Mui+0EgOVZDF8g2owWc3t6WCVyeQAyOH/+vMionI4sjEzDhzuYOYNrvPAePFIrXzUwCt+i88NtVTgxPpwzY/r2UMxivKDOKU/SKEjTqCcewHVU3wecYdZgAgEA0r
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 05, 2026 at 11:24:04PM -0800, Kanchana P. Sridhar wrote:
>  =============================================================================
>    usemem PMD THP BPFTRACE
>  =============================================================================
>            Baseline           zswap           zswap          Change    Change
>         mm-unstable           store        compress            with      with
>          10-25-2026        batching        batching        compress  compress
>                         (patch 6-7)       (patch 8)        batching  batching
>                                                                (ns)       %
>  =============================================================================
>   zswap_store_order0_folio (ns):
>  =============================================================================
>   p50        39,631          37,538          37,765          -1,866    -4.71% 
>   p95        53,088          49,690          49,349          -3,739    -7.04% 
>   p99        65,065          63,529          57,404          -7,661   -11.77%
>  =============================================================================
>   zswap_store_higher_order_folio (ns):
>  =============================================================================
>   p50    21,460,366      21,201,411      20,383,233      -1,077,133    -5.02%
>   p95    25,975,341      27,558,253      25,045,350        -929,991    -3.58%
>   p99    29,538,493      61,926,648      27,184,835      -2,353,658    -7.97%
>  =============================================================================
>   zswap_single_compress_per_page (ns):
>  =============================================================================
>   p50        37,545          39,320          37,218            -327    -0.87%
>   p95        51,549          66,503          51,481             -68    -0.13%
>   p99        89,866         134,854          87,091          -2,775    -3.09%
>  =============================================================================
>   zswap_batch_compress_per_page (ns):            
>  =============================================================================
>   p50                                        40,493           2,948     7.85%
>   p95                                        56,944           5,395    10.47%
>   p99                                        76,242         -13,624   -15.16%
>  =============================================================================

As with previous versions, I cannot reproduce these results. I tried
with a QEMU VM on a Cascade Lake host. I saw marginal improvements with
patch 6 and no significant gain with patches 7-8.

I noticed that you omitted high-level metrics (e.g. throughput), I
didn't see significant changes in throughput, and I also ran a kernel
build and saw a small regression in some cases (probably with order-0
folios) and no significant improvement otherwise. Even if latency for
some functions does improve slightly, it doesn't matter if it doesn't
show up on higher-level metrics.

It could be the difference in setups, or the overhead of bpftrace hooks
for zswap_compress() might affect measured zswap_store() latencies, as
you will have fewer zswap_compress() calls with patch 8.

As advised previously, I would trim down patch 6 to the bare minimum
(without all the scaffolding and prep work for patches 7-8), and send it
separately (with patch 5), and we can check if it's worth adding, I am
still concerned it might be adding overhead for order-0 to be honest.

I am questioning the benefit of batching here without HW batching, so
far the results are more concerning than encouraging. I already spent
too much time trying to reproduce the performance gains. Also, sending
new versions without resolving discussions on previous ones is not
really productive.

